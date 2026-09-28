import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:aiva/platform/process_runner.dart';
import '../support/fixtures.dart';

String dartExecutable() {
  final override = Platform.environment['DART_EXECUTABLE'];
  if (override != null && File(override).existsSync()) return override;
  var root = File(Platform.resolvedExecutable).parent;
  for (var i = 0; i < 9; i++) {
    final binary = Platform.isWindows ? 'dart.exe' : 'dart';
    for (final candidate in [
      p.join(root.path, 'dart-sdk', 'bin', binary),
      p.join(root.path, 'bin', 'cache', 'dart-sdk', 'bin', binary),
    ]) {
      if (File(candidate).existsSync()) return candidate;
    }
    if (root.parent.path == root.path) break;
    root = root.parent;
  }
  throw StateError(
    'Set DART_EXECUTABLE to the real Dart executable inside the Flutter SDK.',
  );
}

void main() {
  final runner = const ProcessRunner();
  Command child(String mode, [List<String> args = const []]) =>
      Command(dartExecutable(), [
        p.join(projectRoot().path, 'test', 'fixtures', 'process_child.dart'),
        mode,
        ...args,
      ]);
  test('drains stdout and stderr while providing unicode input', () async {
    final report = await runner.run(
      child('echo'),
      input: 'Příliš žluťoučký\n42\n',
    );
    expect(report.status, ProcessStatus.success);
    expect(report.stdout, 'Příliš žluťoučký\n42\n');
    expect(report.stderr, 'diagnostika: žluťoučký');
    expect(report.exitCode, 0);
  });
  test('arguments are preserved without shell concatenation', () async {
    final args = [
      'spaces in path',
      'žluťoučký',
      'a"b',
      r'a\b',
      '&not-a-command',
      ';not-a-command',
    ];
    final report = await runner.run(child('args', args));
    expect(report.succeeded, isTrue);
    expect(jsonDecode(report.stdout), args);
  });
  test('nonzero exit is reported with original diagnostic', () async {
    final report = await runner.run(child('fail'));
    expect(report.status, ProcessStatus.failed);
    expect(report.exitCode, 7);
    expect(report.stderr, contains('intentional failure'));
  });
  test('timeout terminates a waiting child', () async {
    final report = await runner.run(
      child('sleep'),
      timeout: const Duration(milliseconds: 800),
    );
    expect(report.status, ProcessStatus.timedOut);
    expect(report.duration.inSeconds, lessThan(8));
  });
  test('cancellation terminates a running child', () async {
    final token = CancellationToken();
    final timer = Timer(const Duration(milliseconds: 800), token.cancel);
    final report = await runner.run(
      child('sleep'),
      cancellation: token,
      timeout: const Duration(seconds: 20),
    );
    timer.cancel();
    expect(report.status, ProcessStatus.cancelled);
  });
  test('pre-cancelled request never launches executable', () async {
    final token = CancellationToken()..cancel();
    final report = await runner.run(
      Command(p.join(projectRoot().path, 'nonexistent'), []),
      cancellation: token,
    );
    expect(report.status, ProcessStatus.cancelled);
  });
  test('captures at most the configured output limit', () async {
    final report = await runner.run(child('flood'), maxOutputBytes: 8192);
    expect(report.status, ProcessStatus.outputLimit);
    expect(report.stdout.length, lessThanOrEqualTo(8192));
  });
  test('missing executable is a structured start failure', () async {
    final report = await runner.run(
      Command(p.join(projectRoot().path, 'definitely-missing.exe'), []),
    );
    expect(report.status, ProcessStatus.startFailed);
    expect(report.stderr, isNotEmpty);
  });
  test('rejects relative executables and Windows batch wrappers', () {
    expect(() => const Command('java', []).validate(), throwsArgumentError);
    expect(
      () => Command(
        p.join(projectRoot().path, 'code.cmd'),
        [],
      ).validate(windows: true),
      throwsArgumentError,
    );
    expect(
      () => Command(dartExecutable(), ['a\x00b']).validate(),
      throwsArgumentError,
    );
  });
  test('Java option injection environment is stripped case insensitively', () {
    final clean = cleanJavaEnvironment({
      'JAVA_TOOL_OPTIONS': '-javaagent:bad.jar',
      '_java_options': 'bad',
      'JDK_JAVA_OPTIONS': 'bad',
      'JDK_JAVAC_OPTIONS': 'bad',
      'CLASSPATH': 'bad',
      'PATH': 'keep',
      'HOME': 'keep',
    });
    expect(clean, {'PATH': 'keep', 'HOME': 'keep'});
  });
}
