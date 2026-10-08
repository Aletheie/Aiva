import 'dart:io';
import 'package:aiva/app/app_controller.dart';
import 'package:aiva/app/aiva_app.dart';
import 'package:aiva/content/course_loader.dart';
import 'package:aiva/platform/app_paths.dart';
import 'package:aiva/ui/components/exercise_studio.dart';
import 'package:aiva/ui/components/java_code_editor.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import '../support/fixtures.dart';
import '../support/memory_store.dart';

void main() {
  late AppController app;
  late Directory root;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('aiva studio test ');
    final source = await realContentInMemory();
    final store = MemoryStore();
    app = AppController(
      course: await CourseLoader(source).load(),
      source: source,
      store: store,
      paths: AppPaths(profile: root.path, workspace: '${root.path}/workspace'),
      profile: await store.load(),
    );
    await app.preference('exerciseEditorMode', 'embedded');
    await app.preference('reducedMotion', 'yes');
  });
  tearDown(() async {
    app.dispose();
    await root.delete(recursive: true);
  });

  Future<void> waitForEditor(WidgetTester tester) async {
    // Workspace refresh uses actual filesystem IO; allow it to finish outside
    // the widget test's fake clock before waiting for animations to settle.
    for (var attempt = 0; attempt < 100; attempt++) {
      await tester.pump();
      if (find
          .byType(JavaCodeEditor, skipOffstage: false)
          .evaluate()
          .isNotEmpty) {
        break;
      }
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
    }
    expect(find.byType(JavaCodeEditor, skipOffstage: false), findsOneWidget);
    await tester.pumpAndSettle();
  }

  Future<void> showStudio(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final lesson = app.course.lessonsById['types']!;
    final index = lesson.exercises.indexWhere(
      (exercise) => exercise.starter != null,
    );
    await tester.runAsync(() => app.editorWorkspace(lesson.exercises[index]));
    await app.openLesson(lesson);
    app.sessionFor(lesson).tab = 1;
    app.sessionFor(lesson).exercise = index;
    await tester.pumpWidget(AivaApp(controller: app));
    await waitForEditor(tester);
  }

  testWidgets(
    'embedded workspace edits real files and keeps buffers across navigation',
    (tester) async {
      await showStudio(tester, const Size(1500, 960));
      expect(find.byType(ExerciseStudio), findsOneWidget);
      expect(find.byType(JavaCodeEditor), findsOneWidget);
      expect(find.text('Spustit kód'), findsOneWidget);
      expect(find.text('Otevřít složku cvičení'), findsNothing);
      final editor = tester.widget<JavaCodeEditor>(find.byType(JavaCodeEditor));
      final updated = '${editor.controller.text}\n// Rozpracovaná poznámka\n';
      editor.controller.text = updated;
      await tester.pump();
      expect(find.text('Neuložené změny'), findsOneWidget);
      final lesson = app.currentLesson!;
      final workspace = (await tester.runAsync(
        () => app.editorWorkspace(
          lesson.exercises[app.sessionFor(lesson).exercise],
        ),
      ))!;
      await tester.runAsync(workspace.saveAll);
      expect(
        await tester.runAsync(() => File(editor.path).readAsString()),
        updated,
      );
      app.go(const PageLocation(AppPage.home));
      await tester.pumpAndSettle();
      app.back();
      await waitForEditor(tester);
      expect(
        tester
            .widget<JavaCodeEditor>(find.byType(JavaCodeEditor))
            .controller
            .text,
        updated,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  for (final theme in ['light', 'dark']) {
    testWidgets('embedded $theme workspace fits narrow window at 160% text', (
      tester,
    ) async {
      await app.preference('theme', theme);
      await app.preference('uiScale', '160');
      await showStudio(tester, const Size(840, 600));
      expect(find.text('Editor a výstup'), findsOneWidget);
      await tester.tap(find.text('Editor a výstup'));
      await tester.pumpAndSettle();
      expect(find.byType(JavaCodeEditor), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
