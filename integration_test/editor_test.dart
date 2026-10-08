import 'dart:io';
import 'dart:ui' as ui;
import 'package:aiva/app/aiva_app.dart';
import 'package:aiva/app/app_controller.dart';
import 'package:aiva/domain/course.dart';
import 'package:aiva/main.dart';
import 'package:aiva/ui/components/java_code_editor.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:re_editor/re_editor.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('native embedded editor saves, runs Java and renders both themes', (
    tester,
  ) async {
    final root = await Directory.systemTemp.createTemp('aiva-editor-native-');
    final app = await loadApplication(profileOverride: root.path);
    await app.preference('workspace', '${root.path}/workspace');
    await app.preference('exerciseEditorMode', 'embedded');
    await app.preference('reducedMotion', 'yes');
    await app.preference('executionConsent', 'yes');
    const server = String.fromEnvironment('AIVA_TEST_JDTLS');
    if (server.isNotEmpty) {
      await app.preference('javaLanguageServerPath', server);
    }
    await app.detectTools();
    final lesson = app.course.lessonsById['types']!;
    final index = lesson.exercises.indexWhere(
      (exercise) => exercise.validation is OutputValidation,
    );
    final exercise = lesson.exercises[index];
    final workspace = await app.editorWorkspace(exercise);
    await app.openLesson(lesson);
    app.sessionFor(lesson).tab = 1;
    app.sessionFor(lesson).exercise = index;
    final capture = GlobalKey();
    Future<void> screenshot(String name) async {
      const destination = String.fromEnvironment('AIVA_SCREENSHOT_DIR');
      if (destination.isEmpty) return;
      await tester.pumpAndSettle();
      final boundary =
          capture.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 1);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      final file = File('$destination/$name.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(data!.buffer.asUint8List());
    }

    try {
      await tester.pumpWidget(
        RepaintBoundary(
          key: capture,
          child: AivaApp(controller: app),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(JavaCodeEditor), findsOneWidget);
      await screenshot('exercise-studio-light');
      await app.preference('theme', 'dark');
      await tester.pumpAndSettle();
      await screenshot('exercise-studio-dark');
      final editor = tester.widget<JavaCodeEditor>(find.byType(JavaCodeEditor));
      if (server.isNotEmpty) {
        final readyDeadline = DateTime.now().add(const Duration(seconds: 90));
        while (!editor.languageService.isReady &&
            DateTime.now().isBefore(readyDeadline)) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        expect(
          editor.languageService.isReady,
          isTrue,
          reason: editor.languageService.statusMessage,
        );
        editor.controller.text =
            'class Main {\n  public static void main(String[] args) {\n    String message = "Aiva";\n    message.sub\n  }\n}\n';
        await tester.pumpAndSettle();
        tester
            .widget<CodeEditor>(find.byType(CodeEditor))
            .focusNode!
            .requestFocus();
        await tester.pump();
        editor.controller.selection = const CodeLineSelection.collapsed(
          index: 3,
          offset: 15,
        );
        await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
        final completionDeadline = DateTime.now().add(
          const Duration(seconds: 30),
        );
        while (find
                .textContaining('substring(', findRichText: true)
                .evaluate()
                .isEmpty &&
            DateTime.now().isBefore(completionDeadline)) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        expect(
          find.textContaining('substring(', findRichText: true),
          findsWidgets,
        );
        // JDT orders subSequence before the two substring overloads.
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        await screenshot('exercise-studio-intellisense');
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        for (
          var i = 0;
          i < 100 && !editor.controller.text.contains('message.substring');
          i++
        ) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        expect(editor.controller.text, contains('message.substring'));
      }
      editor.controller.text =
          'class Main { public static void main(String[] args) { System.out.println("Aiva funguje"); } }\n';
      await workspace.saveAll();
      expect(await File(editor.path).readAsString(), contains('Aiva funguje'));
      expect(
        app.selectedJdk,
        isNotNull,
        reason: 'Native smoke test requires JDK 21+.',
      );
      await tester.tap(find.byKey(const ValueKey('run-embedded-code')));
      final deadline = DateTime.now().add(const Duration(seconds: 45));
      while (app.programRuns[exercise.id] == null &&
          DateTime.now().isBefore(deadline)) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(app.programRuns[exercise.id]?.stdout.trim(), 'Aiva funguje');
      expect(app.profile.exercise(exercise.id), ExerciseState.attempted);
      await tester.pumpAndSettle();
      await screenshot('exercise-studio-run');
      app.go(const PageLocation(AppPage.settings));
      await tester.pumpAndSettle();
      await screenshot('exercise-studio-settings');
      await app.openLesson(app.course.lessonsById['signed-unsigned']!);
      await tester.pumpAndSettle();
      await screenshot('signed-unsigned-lesson');
      expect(tester.takeException(), isNull);
    } finally {
      await tester.pumpWidget(const SizedBox.shrink());
      await app.saveEditorWorkspaces();
      app.dispose();
      await root.delete(recursive: true);
    }
  });
}
