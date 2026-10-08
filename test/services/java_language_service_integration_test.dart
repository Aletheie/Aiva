import 'dart:io';

import 'package:aiva/services/java_language_service.dart';
import 'package:aiva/services/tool_discovery.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// Opt-in smoke test against an actual Eclipse JDT LS distribution and JDK.
/// AIVA_TEST_JDTLS=/absolute/server AIVA_TEST_JDK=/absolute/jdk flutter test ...
void main() {
  final server = Platform.environment['AIVA_TEST_JDTLS'];
  final jdkHome = Platform.environment['AIVA_TEST_JDK'];
  for (final mavenProject in [false, true]) {
    test(
      'real JDT LS offers completion, hover and diagnostics for ${mavenProject ? 'a Maven course starter offline' : 'a standalone source'}',
      () async {
        final temporary = await Directory.systemTemp.createTemp(
          'aiva-jdtls-live-',
        );
        final workspace = Directory(await temporary.resolveSymbolicLinks());
        final service = JavaLanguageService();
        addTearDown(() async {
          await service.stop();
          service.dispose();
          await workspace.delete(recursive: true);
        });
        final jdk = await const ToolDiscovery().inspectJdk(jdkHome!);
        if (mavenProject) {
          await File(
            'content/starters/ex-variables-ticket-desk/pom.xml',
          ).copy(p.join(workspace.path, 'pom.xml'));
        }
        final source = File(
          p.join(
            workspace.path,
            mavenProject ? 'src/main/java' : '',
            'Main.java',
          ),
        );
        await source.parent.create(recursive: true);
        await File(p.join(source.parent.path, 'Greeting.java')).writeAsString(
          'class Greeting { static String message() { return "hello"; } }',
        );
        const content =
            'class Main {\n  public static void main(String[] args) {\n    String message = "hello";\n    message.sub\n  }\n}\n';
        await source.writeAsString(content);
        await service.start(
          jdk: jdk,
          workspacePath: workspace.path,
          serverPath: server!,
        );
        expect(
          service.state,
          JavaLanguageState.ready,
          reason: service.statusMessage,
        );
        service.openDocument(source.path, content);
        final offset = content.indexOf('message.sub') + 'message.sub'.length;
        List<JavaCompletion> completions = [];
        final deadline = DateTime.now().add(const Duration(seconds: 45));
        while (completions.isEmpty && DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(seconds: 1));
          completions = await service.complete(source.path, content, offset);
        }
        expect(
          completions.any((item) => item.label.startsWith('substring')),
          isTrue,
          reason:
              'Expected semantic String member completion, got ${completions.map((item) => item.label).join(', ')}',
        );
        final selected = await service.resolveCompletion(
          completions.firstWhere((item) => item.label.startsWith('substring')),
        );
        expect(
          selected.apply(content, offset).text,
          contains('message.substring'),
        );
        final hover = await service.hover(
          source.path,
          content,
          content.indexOf('String message') + 2,
        );
        expect(hover, contains('String'));
        final diagnosticsDeadline = DateTime.now().add(
          const Duration(seconds: 20),
        );
        while ((service.diagnostics[source.path] ?? []).isEmpty &&
            DateTime.now().isBefore(diagnosticsDeadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 500));
        }
        expect(
          service.diagnostics[source.path]?.any((item) => item.severity == 1),
          isTrue,
          reason: 'Diagnostics: ${service.diagnostics}',
        );
        // A real semantic error after an unsaved edit must replace the initial
        // syntax diagnostics; this also verifies didChange/version handling.
        final invalid = content.replaceFirst(
          'message.sub',
          'int count = "bad";',
        );
        service.changeDocument(source.path, invalid);
        final changeDeadline = DateTime.now().add(const Duration(seconds: 20));
        bool hasTypeError() => (service.diagnostics[source.path] ?? []).any(
          (item) => item.message.contains('String to int'),
        );
        while (!hasTypeError() && DateTime.now().isBefore(changeDeadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 250));
        }
        expect(
          hasTypeError(),
          isTrue,
          reason:
              '${service.diagnostics[source.path]?.map((item) => item.message).join(', ')}',
        );
        // Resolving a sibling file confirms this is a real source project,
        // including course starters whose pom.xml must not require downloads.
        final crossFile = content.replaceFirst('message.sub', 'Greeting.mess');
        final crossFileOffset =
            crossFile.indexOf('Greeting.mess') + 'Greeting.mess'.length;
        final crossFileCompletions = await service.complete(
          source.path,
          crossFile,
          crossFileOffset,
        );
        expect(
          crossFileCompletions.any((item) => item.label.startsWith('message')),
          isTrue,
          reason: 'Expected a static method from sibling Greeting.java.',
        );
      },
      skip: server == null || jdkHome == null
          ? 'Set AIVA_TEST_JDTLS and AIVA_TEST_JDK to run the real server smoke test.'
          : false,
      timeout: const Timeout(Duration(minutes: 3)),
    );
  }
}
