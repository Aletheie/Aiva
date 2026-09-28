import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;

final class CancellationToken {
  final Completer<void> _completer = Completer<void>();
  bool get isCancelled => _completer.isCompleted;
  Future<void> get whenCancelled => _completer.future;
  void cancel() {
    if (!isCancelled) _completer.complete();
  }
}

enum ProcessStatus {
  success,
  failed,
  timedOut,
  cancelled,
  outputLimit,
  startFailed,
}

final class ProcessReport {
  const ProcessReport({
    required this.status,
    required this.stdout,
    required this.stderr,
    this.exitCode,
    required this.duration,
  });
  final ProcessStatus status;
  final String stdout;
  final String stderr;
  final int? exitCode;
  final Duration duration;
  bool get succeeded => status == ProcessStatus.success;
}

final class Command {
  const Command(this.executable, this.arguments, {this.workingDirectory});
  final String executable;
  final List<String> arguments;
  final String? workingDirectory;
  void validate({bool? windows}) {
    if (!p.isAbsolute(executable) ||
        executable.contains('\x00') ||
        arguments.any((a) => a.contains('\x00')) ||
        (workingDirectory != null && !p.isAbsolute(workingDirectory!))) {
      throw ArgumentError(
        'Příkaz vyžaduje absolutní cestu a argumenty bez NUL.',
      );
    }
    if ((windows ?? Platform.isWindows) &&
        RegExp(r'\.(bat|cmd)$', caseSensitive: false).hasMatch(executable)) {
      throw ArgumentError('Vyber přímo .exe, nikoli .bat/.cmd.');
    }
  }
}

Map<String, String> cleanJavaEnvironment(Map<String, String> environment) =>
    Map.fromEntries(
      environment.entries.where(
        (e) => !{
          'JAVA_TOOL_OPTIONS',
          '_JAVA_OPTIONS',
          'JDK_JAVA_OPTIONS',
          'JDK_JAVAC_OPTIONS',
          'CLASSPATH',
        }.contains(e.key.toUpperCase()),
      ),
    );

/// Limits runtime and output. Child processes run with the user's permissions.
final class ProcessRunner {
  const ProcessRunner();
  Future<ProcessReport> run(
    Command command, {
    String input = '',
    Duration timeout = const Duration(seconds: 5),
    int maxOutputBytes = 128 * 1024,
    CancellationToken? cancellation,
  }) async {
    final clock = Stopwatch()..start();
    if (cancellation?.isCancelled ?? false) {
      return ProcessReport(
        status: ProcessStatus.cancelled,
        stdout: '',
        stderr: '',
        duration: clock.elapsed,
      );
    }
    if (maxOutputBytes < 1 || timeout <= Duration.zero) {
      throw ArgumentError('Neplatný limit procesu.');
    }
    late final Process child;
    try {
      command.validate();
      child = await Process.start(
        command.executable,
        command.arguments,
        workingDirectory: command.workingDirectory,
        environment: cleanJavaEnvironment(Platform.environment),
        includeParentEnvironment: false,
        runInShell: false,
      );
    } on Object catch (error) {
      return ProcessReport(
        status: ProcessStatus.startFailed,
        stdout: '',
        stderr: error.toString(),
        duration: clock.elapsed,
      );
    }
    final out = BytesBuilder(copy: false);
    final err = BytesBuilder(copy: false);
    final outDone = Completer<void>();
    final errDone = Completer<void>();
    var seen = 0;
    var timedOut = false;
    var limited = false;
    var cancelled = false;
    var finished = false;
    String? ioError;
    int? exitCode;
    Future<void>? termination;
    Future<void> stop() => termination ??= _terminate(child);
    void consume(List<int> chunk, BytesBuilder buffer) {
      final remaining = maxOutputBytes - seen;
      if (remaining > 0) {
        buffer.add(
          chunk.length <= remaining ? chunk : chunk.sublist(0, remaining),
        );
      }
      seen += chunk.length;
      if (seen > maxOutputBytes && !limited) {
        limited = true;
        unawaited(stop());
      }
    }

    void streamError(Object error, Completer<void> done) {
      ioError = error.toString();
      if (!done.isCompleted) done.complete();
    }

    final outSubscription = child.stdout.listen(
      (chunk) => consume(chunk, out),
      onDone: () {
        if (!outDone.isCompleted) outDone.complete();
      },
      onError: (Object e) => streamError(e, outDone),
    );
    final errSubscription = child.stderr.listen(
      (chunk) => consume(chunk, err),
      onDone: () {
        if (!errDone.isCompleted) errDone.complete();
      },
      onError: (Object e) => streamError(e, errDone),
    );
    final timer = Timer(timeout, () {
      timedOut = true;
      unawaited(stop());
    });
    if (cancellation != null) {
      unawaited(
        cancellation.whenCancelled.then((_) {
          if (!finished) {
            cancelled = true;
            unawaited(stop());
          }
        }),
      );
      if (cancellation.isCancelled) {
        cancelled = true;
        unawaited(stop());
      }
    }
    try {
      child.stdin.add(utf8.encode(input));
      unawaited(child.stdin.close().catchError((Object _) {}));
      await Future.wait<void>([
        child.exitCode.then((code) {
          exitCode = code;
        }),
        outDone.future,
        errDone.future,
      ]).timeout(timeout + const Duration(seconds: 5));
    } on TimeoutException {
      timedOut = true;
      await stop();
    } on Object catch (error) {
      ioError = error.toString();
      await stop();
    } finally {
      finished = true;
      timer.cancel();
      if (termination != null) await termination;
      await outSubscription.cancel();
      await errSubscription.cancel();
    }
    return ProcessReport(
      status: cancelled
          ? ProcessStatus.cancelled
          : timedOut
          ? ProcessStatus.timedOut
          : limited
          ? ProcessStatus.outputLimit
          : exitCode == 0 && ioError == null
          ? ProcessStatus.success
          : ProcessStatus.failed,
      stdout: utf8.decode(out.takeBytes(), allowMalformed: true),
      stderr:
          '${utf8.decode(err.takeBytes(), allowMalformed: true)}${ioError == null ? '' : '\n$ioError'}',
      exitCode: exitCode,
      duration: clock.elapsed,
    );
  }

  Future<void> _terminate(Process child) async {
    try {
      if (Platform.isWindows) {
        final system = Platform.environment['SystemRoot'] ?? r'C:\Windows';
        final taskkill = p.join(system, 'System32', 'taskkill.exe');
        await Process.run(taskkill, [
          '/PID',
          '${child.pid}',
          '/T',
          '/F',
        ], runInShell: false).timeout(const Duration(seconds: 2));
      } else {
        // This snapshot misses descendants spawned while termination is underway.
        final ps = await Process.run('/bin/ps', [
          '-A',
          '-o',
          'pid=',
          '-o',
          'ppid=',
        ], runInShell: false).timeout(const Duration(seconds: 2));
        final children = <int, List<int>>{};
        for (final line in (ps.stdout as String).split('\n')) {
          final columns = line.trim().split(RegExp(r'\s+'));
          if (columns.length != 2) continue;
          final pid = int.tryParse(columns[0]);
          final parent = int.tryParse(columns[1]);
          if (pid != null && parent != null) (children[parent] ??= []).add(pid);
        }
        final visited = <int>{};
        void killDescendants(int parent) {
          if (!visited.add(parent)) return;
          for (final pid in children[parent] ?? <int>[]) {
            killDescendants(pid);
            try {
              Process.killPid(pid, ProcessSignal.sigkill);
            } on Object {
              // The descendant may have exited.
            }
          }
        }

        killDescendants(child.pid);
      }
    } on Object {
      // Still terminate the child if descendant lookup fails.
    }
    try {
      child.kill(
        Platform.isWindows ? ProcessSignal.sigterm : ProcessSignal.sigkill,
      );
    } on Object {
      // The child may have exited.
    }
  }
}
