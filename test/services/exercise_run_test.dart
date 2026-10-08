import 'dart:io';

import 'package:aiva/domain/course.dart';
import 'package:aiva/platform/process_runner.dart';
import 'package:aiva/services/exercise_runner.dart';
import 'package:aiva/services/tool_discovery.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  const validation = OutputValidation(
    mainClass: 'Main',
    javaRelease: 21,
    timeoutMs: 2500,
    cases: [OutputCase(input: 'test input', expected: 'test output')],
  );
  final home = Platform.environment['JAVA_HOME'];
  group('single program run', () {
    late Directory root;
    late JdkInstallation jdk;
    setUpAll(() async => jdk = await const ToolDiscovery().inspectJdk(home!));
    setUp(
      () async =>
          root = await Directory.systemTemp.createTemp('Aiva run žluťoučký '),
    );
    tearDown(() => root.delete(recursive: true));

    Future<void> source(String body) async {
      final file = File(p.join(root.path, 'src/main/java/Main.java'));
      await file.parent.create(recursive: true);
      await file.writeAsString(
        'public class Main { public static void main(String[] args) throws Exception { $body } }',
      );
    }

    Future<RunReport> run({
      String input = '',
      CancellationToken? cancellation,
    }) => const ExerciseRunner().run(
      workspace: root.path,
      jdk: jdk,
      validation: validation,
      cancellation: cancellation ?? CancellationToken(),
      input: input,
    );

    test(
      'uses custom UTF-8 stdin, keeps stderr, and does not grade against cases',
      () async {
        await source(
          'System.out.write(System.in.readAllBytes()); System.err.print("detail");',
        );
        final report = await run(input: 'Tvoje zadání\n42\n');
        expect(report.succeeded, isTrue);
        expect(report.stdout, 'Tvoje zadání\n42\n');
        expect(report.stderr, 'detail');
        expect(report.exitCode, 0);
        expect(report.duration, greaterThan(Duration.zero));
        expect(
          await root
              .list(recursive: true)
              .where((entry) => entry.path.endsWith('.class'))
              .isEmpty,
          isTrue,
        );
      },
    );

    test(
      'returns compiler diagnostics and never runs invalid sources',
      () async {
        await source('int value = ;');
        final report = await run();
        expect(report.status, CheckStatus.compileError);
        expect(report.succeeded, isFalse);
        expect(report.diagnostics, contains('Main.java'));
      },
    );

    test('retains output and stack trace on runtime failure', () async {
      await source(
        'System.out.print("before"); throw new IllegalStateException("run-error");',
      );
      final report = await run();
      expect(report.status, CheckStatus.runtimeError);
      expect(report.stdout, 'before');
      expect(report.stderr, contains('run-error'));
      expect(report.exitCode, isNot(0));
    });

    test('cancels before source access and between compile and run', () async {
      final token = CancellationToken()..cancel();
      expect((await run(cancellation: token)).status, CheckStatus.cancelled);
      await source('System.out.print("should not run");');
      final lateToken = CancellationToken();
      final report = await const ExerciseRunner().run(
        workspace: root.path,
        jdk: jdk,
        validation: validation,
        cancellation: lateToken,
        onStage: (stage) {
          if (stage == 'Spouštím program…') lateToken.cancel();
        },
      );
      expect(report.status, CheckStatus.cancelled);
      expect(report.stdout, isEmpty);
    });

    test('enforces runtime and output limits', () async {
      await source('Thread.sleep(30000);');
      expect((await run()).status, CheckStatus.timedOut);
      await source('while (true) System.out.print("0123456789".repeat(1000));');
      final report = await run();
      expect(report.status, CheckStatus.outputLimit);
      expect(report.stdout.length, lessThanOrEqualTo(128 * 1024));
    });
  }, skip: home == null ? 'JAVA_HOME not set; requires JDK 21+.' : false);
}
