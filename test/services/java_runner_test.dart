import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:aiva/domain/course.dart';
import 'package:aiva/content/content_source.dart';
import 'package:aiva/services/workspace_service.dart';
import 'package:aiva/platform/process_runner.dart';
import 'package:aiva/services/exercise_runner.dart';
import 'package:aiva/services/tool_discovery.dart';
import '../support/fixtures.dart';

void main() {
  final home = Platform.environment['JAVA_HOME'];
  final requiredJdk = Platform.environment['AIVA_REQUIRE_JDK_TESTS'] == '1';
  test('JDK integration prerequisite is explicit', () {
    if (requiredJdk) {
      expect(
        home,
        isNotNull,
        reason: 'CI requires JAVA_HOME pointing to JDK 21+.',
      );
    }
  });
  group(
    'real javac/java through the new Dart runner',
    () {
      late JdkInstallation jdk;
      late Directory root;
      setUpAll(() async {
        jdk = await const ToolDiscovery().inspectJdk(home!);
      });
      setUp(
        () async =>
            root = await Directory.systemTemp.createTemp('AIVA runner žlutý '),
      );
      tearDown(() async => root.delete(recursive: true));
      test('all 97 reference solutions and 418 cases pass', () async {
        final course = await realCourse();
        var programs = 0;
        var cases = 0;
        for (final exercise in course.lessons.expand((l) => l.exercises)) {
          final validation = exercise.validation;
          if (validation is! OutputValidation) continue;
          final original = Directory(
            p.join(projectRoot().path, 'tests', 'java-solutions', exercise.id),
          );
          final target = Directory(p.join(root.path, exercise.id));
          await for (final file in original.list(
            recursive: true,
            followLinks: false,
          )) {
            if (file is! File) continue;
            final destination = File(
              p.join(target.path, p.relative(file.path, from: original.path)),
            );
            await destination.parent.create(recursive: true);
            await file.copy(destination.path);
          }
          final report = await const ExerciseRunner().check(
            workspace: target.path,
            jdk: jdk,
            validation: validation,
            cancellation: CancellationToken(),
          );
          expect(
            report.passed,
            isTrue,
            reason: '${exercise.id}: ${report.message}\n${report.diagnostics}',
          );
          programs++;
          cases += report.cases.length;
        }
        expect(programs, 97);
        expect(cases, 418);
      }, timeout: const Timeout(Duration(minutes: 10)));
      test('solutions displayed to students pass all output cases', () async {
        final course = await realCourse();
        final workspaces = WorkspaceService(
          DirectoryContentSource(p.join(projectRoot().path, 'content')),
        );
        var checked = 0;
        for (final exercise in course.lessons.expand(
          (lesson) => lesson.exercises,
        )) {
          final validation = exercise.validation;
          if (validation is! OutputValidation) continue;
          final workspace = await workspaces.prepare(root.path, exercise);
          final blocks = RegExp(
            r'```java\s*\n([\s\S]*?)```',
          ).allMatches(exercise.solution);
          expect(blocks, isNotEmpty, reason: exercise.id);
          for (final block in blocks) {
            final code = block[1]!;
            final className = RegExp(
              r'\bclass\s+([A-Za-z_$][A-Za-z0-9_$]*)',
            ).firstMatch(code)?[1];
            expect(className, isNotNull, reason: exercise.id);
            await File(
              p.join(workspace.path, 'src/main/java', '$className.java'),
            ).writeAsString(code);
          }
          final report = await const ExerciseRunner().check(
            workspace: workspace.path,
            jdk: jdk,
            validation: validation,
            cancellation: CancellationToken(),
          );
          expect(
            report.passed,
            isTrue,
            reason: '${exercise.id}: ${report.message}\n${report.diagnostics}',
          );
          checked += report.cases.length;
        }
        expect(checked, 418);
      }, timeout: const Timeout(Duration(minutes: 10)));
      test('unfinished and broken starters do not pass as solutions', () async {
        final course = await realCourse();
        final workspaces = WorkspaceService(
          DirectoryContentSource(p.join(projectRoot().path, 'content')),
        );
        final unexpected = <String>[];
        for (final exercise in course.lessons.expand((l) => l.exercises)) {
          final validation = exercise.validation;
          if (validation is! OutputValidation) continue;
          final workspace = await workspaces.prepare(root.path, exercise);
          final report = await const ExerciseRunner().check(
            workspace: workspace.path,
            jdk: jdk,
            validation: validation,
            cancellation: CancellationToken(),
          );
          if (report.passed != (exercise.id == 'ex-setup-ready')) {
            unexpected.add('${exercise.id}: ${report.message}');
          }
        }
        expect(
          unexpected,
          isEmpty,
          reason: 'Only the toolchain check starts solved.',
        );
      }, timeout: const Timeout(Duration(minutes: 8)));
      Future<String> workspace(String code) async {
        final file = File(p.join(root.path, 'src/main/java/Main.java'));
        await file.parent.create(recursive: true);
        await file.writeAsString(code);
        return root.path;
      }

      const validation = OutputValidation(
        mainClass: 'Main',
        javaRelease: 21,
        timeoutMs: 800,
        cases: [OutputCase(input: '', expected: 'wanted\n')],
      );
      test('compiler errors preserve javac diagnostics', () async {
        await workspace(
          'public class Main { public static void main(String[] args) { int x = ; } }',
        );
        final report = await const ExerciseRunner().check(
          workspace: root.path,
          jdk: jdk,
          validation: validation,
          cancellation: CancellationToken(),
        );
        expect(report.status, CheckStatus.compileError);
        expect(report.diagnostics, contains('Main.java'));
      });
      test('wrong output shows expected and actual, not success', () async {
        await workspace(
          'public class Main { public static void main(String[] args) { System.out.println("other"); } }',
        );
        final report = await const ExerciseRunner().check(
          workspace: root.path,
          jdk: jdk,
          validation: validation,
          cancellation: CancellationToken(),
        );
        expect(report.status, CheckStatus.wrongOutput);
        expect(report.cases.single.actual, 'other\n');
      });
      test('runtime failure includes the Java stack trace', () async {
        await workspace(
          'public class Main { public static void main(String[] args) { throw new RuntimeException("test-error"); } }',
        );
        final report = await const ExerciseRunner().check(
          workspace: root.path,
          jdk: jdk,
          validation: validation,
          cancellation: CancellationToken(),
        );
        expect(report.status, CheckStatus.runtimeError);
        expect(report.diagnostics, contains('test-error'));
        expect(report.cases.single.number, 1);
        expect(report.cases.single.expected, 'wanted\n');
        expect(report.cases.single.problem, isNotNull);
      });
      test('long-running Java program times out', () async {
        await workspace(
          'public class Main { public static void main(String[] args) throws Exception { Thread.sleep(30000); } }',
        );
        final report = await const ExerciseRunner().check(
          workspace: root.path,
          jdk: jdk,
          validation: validation,
          cancellation: CancellationToken(),
        );
        expect(report.status, CheckStatus.timedOut);
      });
      test(
        'command construction preserves absolute source paths and prevents annotation processors',
        () {
          final output = p.join(root.path, 'classes');
          final command = compileCommand(
            jdk,
            [p.join(root.path, 'src/main/java/My File.java')],
            output,
            root.path,
            21,
          );
          expect(command.arguments, contains('-proc:none'));
          expect(command.arguments, contains('--release'));
          expect(
            command.arguments.last,
            p.join(root.path, 'src/main/java/My File.java'),
          );
          expect(
            () => javaCommand(jdk, output, root.path, 'Main;echo bad'),
            throwsArgumentError,
          );
        },
      );
    },
    skip: home == null
        ? 'JAVA_HOME not set; these are integration tests requiring JDK 21+.'
        : false,
  );
}
