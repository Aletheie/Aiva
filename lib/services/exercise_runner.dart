import 'dart:io';
import 'package:path/path.dart' as p;
import '../domain/course.dart';
import '../platform/process_runner.dart';
import 'tool_discovery.dart';
import 'workspace_service.dart';

enum CheckStatus {
  passed,
  wrongOutput,
  compileError,
  runtimeError,
  timedOut,
  cancelled,
  outputLimit,
  unavailable,
}

final class CaseResult {
  const CaseResult({
    required this.number,
    required this.input,
    required this.expected,
    required this.actual,
    required this.stderr,
    required this.passed,
    this.problem,
  });
  final int number;
  final String input;
  final String expected;
  final String actual;
  final String stderr;
  final bool passed;
  final String? problem;
}

final class ValidationReport {
  const ValidationReport({
    required this.status,
    required this.message,
    this.diagnostics = '',
    this.cases = const [],
    this.totalCases = 0,
  });
  final CheckStatus status;
  final String message;
  final String diagnostics;
  final List<CaseResult> cases;
  final int totalCases;
  bool get passed => status == CheckStatus.passed;
}

Command compileCommand(
  JdkInstallation jdk,
  List<String> sources,
  String output,
  String workspace,
  int release,
) {
  if (release < 21 ||
      release > 25 ||
      !p.isAbsolute(output) ||
      sources.isEmpty ||
      sources.any((s) => !p.isAbsolute(s))) {
    throw ArgumentError('Neplatné parametry kompilace.');
  }
  return Command(jdk.javac, [
    '-J-Xmx256m',
    '-J-Duser.language=en',
    '-encoding',
    'UTF-8',
    '--release',
    '$release',
    '-proc:none',
    '-d',
    output,
    '-classpath',
    output,
    ...sources,
  ], workingDirectory: workspace);
}

Command javaCommand(
  JdkInstallation jdk,
  String output,
  String workspace,
  String mainClass,
) {
  if (!p.isAbsolute(output) ||
      !RegExp(
        r'^[A-Za-z_$][A-Za-z0-9_$]*(?:\.[A-Za-z_$][A-Za-z0-9_$]*)*$',
      ).hasMatch(mainClass)) {
    throw ArgumentError('Neplatná cesta nebo hlavní třída.');
  }
  return Command(jdk.java, [
    '-Xmx128m',
    '-Dfile.encoding=UTF-8',
    '-Duser.language=en',
    '-Duser.country=US',
    '-cp',
    output,
    mainClass,
  ], workingDirectory: workspace);
}

final class ExerciseRunner {
  const ExerciseRunner({this.processes = const ProcessRunner()});
  final ProcessRunner processes;
  Future<ValidationReport> check({
    required String workspace,
    required JdkInstallation jdk,
    required OutputValidation validation,
    required CancellationToken cancellation,
    void Function(String message)? onStage,
  }) async {
    if (jdk.major < validation.javaRelease) {
      return ValidationReport(
        status: CheckStatus.unavailable,
        message:
            'Tato úloha potřebuje JDK ${validation.javaRelease} nebo novější.',
      );
    }
    Directory? temporary;
    try {
      if (cancellation.isCancelled) return _cancelled();
      onStage?.call('Načítám uložené Java soubory…');
      final sources = await WorkspaceService.javaSources(workspace);
      temporary = await Directory.systemTemp.createTemp('aiva-check-');
      final classes = await Directory(
        p.join(temporary.path, 'classes'),
      ).create();
      onStage?.call('Překládám pomocí javac…');
      final compiled = await processes.run(
        compileCommand(
          jdk,
          sources,
          classes.path,
          workspace,
          validation.javaRelease,
        ),
        timeout: const Duration(seconds: 20),
        cancellation: cancellation,
      );
      if (!compiled.succeeded) {
        return _processFailure(compiled, compiling: true);
      }
      final cases = <CaseResult>[];
      for (var i = 0; i < validation.cases.length; i++) {
        if (cancellation.isCancelled) return _cancelled();
        onStage?.call(
          'Kontroluji případ ${i + 1} z ${validation.cases.length}…',
        );
        final testCase = validation.cases[i];
        final run = await processes.run(
          javaCommand(jdk, classes.path, workspace, validation.mainClass),
          input: testCase.input,
          timeout: Duration(milliseconds: validation.timeoutMs),
          cancellation: cancellation,
        );
        if (!run.succeeded) {
          final failure = _processFailure(run, compiling: false);
          cases.add(
            CaseResult(
              number: i + 1,
              input: testCase.input,
              expected: testCase.expected,
              actual: run.stdout,
              stderr: run.stderr,
              passed: false,
              problem: failure.message,
            ),
          );
          return ValidationReport(
            status: failure.status,
            message: 'Test ${i + 1}: ${failure.message}',
            diagnostics: failure.diagnostics,
            cases: List.unmodifiable(cases),
            totalCases: validation.cases.length,
          );
        }
        cases.add(
          CaseResult(
            number: i + 1,
            input: testCase.input,
            expected: testCase.expected,
            actual: run.stdout,
            stderr: run.stderr,
            passed:
                normalizeOutput(run.stdout) ==
                normalizeOutput(testCase.expected),
          ),
        );
      }
      final passed = cases.every((c) => c.passed);
      return ValidationReport(
        status: passed ? CheckStatus.passed : CheckStatus.wrongOutput,
        message: passed
            ? 'Kontrola dokončena: ${cases.length} z ${cases.length} testů prošlo.'
            : 'Výstup se v některém případě liší od zadání.',
        cases: List.unmodifiable(cases),
        totalCases: validation.cases.length,
      );
    } on Object catch (error) {
      return ValidationReport(
        status: CheckStatus.unavailable,
        message: 'Kontrolu se nepodařilo dokončit.',
        diagnostics: error.toString(),
      );
    } finally {
      if (temporary != null && await temporary.exists()) {
        try {
          await temporary.delete(recursive: true);
        } on FileSystemException {
          /* OS may still hold a handle. */
        }
      }
    }
  }

  static ValidationReport _cancelled() => const ValidationReport(
    status: CheckStatus.cancelled,
    message: 'Kontrola byla zrušena.',
  );
  static ValidationReport _processFailure(
    ProcessReport report, {
    required bool compiling,
  }) {
    final status = switch (report.status) {
      ProcessStatus.cancelled => CheckStatus.cancelled,
      ProcessStatus.timedOut => CheckStatus.timedOut,
      ProcessStatus.outputLimit => CheckStatus.outputLimit,
      ProcessStatus.startFailed => CheckStatus.unavailable,
      _ => compiling ? CheckStatus.compileError : CheckStatus.runtimeError,
    };
    final message = switch (status) {
      CheckStatus.cancelled => 'Kontrola byla zrušena.',
      CheckStatus.timedOut =>
        compiling
            ? 'Překlad překročil časový limit.'
            : 'Program překročil časový limit. Zkontroluj cykly a čtení vstupu.',
      CheckStatus.outputLimit => 'Program překročil limit 128 KiB výstupu.',
      CheckStatus.compileError =>
        'Překladač našel chybu. Níže je jeho přesné hlášení.',
      CheckStatus.runtimeError =>
        'Program skončil chybou za běhu (exit ${report.exitCode}).',
      _ => 'Nástroj se nepodařilo spustit. Zkontroluj cestu k JDK.',
    };
    final raw = '${report.stdout}${report.stderr}';
    return ValidationReport(
      status: status,
      message: message,
      diagnostics: '$raw${compilerHint(raw)}',
    );
  }
}

String compilerHint(String diagnostic) {
  if (diagnostic.contains("';' expected")) {
    return '\n\nVysvětlení: poblíž označeného místa pravděpodobně chybí středník.';
  }
  if (diagnostic.contains('missing return statement')) {
    return '\n\nVysvětlení: některá cesta metodou nevrací požadovanou hodnotu.';
  }
  if (diagnostic.contains('cannot find symbol')) {
    return '\n\nVysvětlení: překladač nezná uvedené jméno. Zkontroluj překlep a rozsah platnosti.';
  }
  return '';
}
