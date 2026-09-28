import 'dart:io';
import 'dart:ui' show PointerDeviceKind;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aiva/app/app_controller.dart';
import 'package:aiva/app/aiva_app.dart';
import 'package:aiva/content/course_loader.dart';
import 'package:aiva/domain/course.dart';
import 'package:aiva/platform/app_paths.dart';
import 'package:aiva/ui/components/code_block.dart';
import 'package:aiva/ui/components/exercise_card.dart';
import 'package:aiva/ui/components/exercise_story.dart';
import 'package:aiva/ui/components/lesson_markdown.dart';
import '../support/fixtures.dart';
import '../support/memory_store.dart';

void main() {
  late AppController app;
  late Directory root;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('aiva widgets ');
    final source = await realContentInMemory();
    final store = MemoryStore();
    app = AppController(
      course: await CourseLoader(source).load(),
      source: source,
      store: store,
      paths: AppPaths(profile: root.path, workspace: '${root.path}/workspaces'),
      profile: await store.load(),
    );
  });
  tearDown(() async {
    app.dispose();
    await root.delete(recursive: true);
  });
  Future<void> showApp(
    WidgetTester tester, {
    Size size = const Size(1320, 900),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(AivaApp(controller: app));
    await tester.pumpAndSettle();
  }

  Future<void> usePlannedFilesFixture() async {
    final source = await contentWithPlannedFilesLesson(
      app.source as MemoryContent,
    );
    final store = MemoryStore();
    app.dispose();
    app = AppController(
      course: await CourseLoader(source).load(),
      source: source,
      store: store,
      paths: AppPaths(profile: root.path, workspace: '${root.path}/workspaces'),
      profile: await store.load(),
    );
  }

  testWidgets(
    'stories are optional, keyboard accessible and reset between exercises',
    (tester) async {
      final first = app.course.lessonsById['types']!.exercises.first;
      final second =
          app.course.lessonsById['encapsulation-overview']!.exercises.first;
      final selected = ValueNotifier(first);
      addTearDown(selected.dispose);
      await tester.pumpWidget(
        FluentApp(
          home: MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(1.6),
              disableAnimations: true,
            ),
            child: ScaffoldPage(
              content: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 400,
                    child: ValueListenableBuilder<Exercise>(
                      valueListenable: selected,
                      builder: (context, exercise, _) => ExerciseCard(
                        controller: app,
                        exercise: exercise,
                        showHeading: false,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final expander = find.descendant(
        of: find.byType(ExerciseStoryPanel),
        matching: find.byType(Expander),
      );
      expect(tester.state<ExpanderState>(expander).isExpanded, isFalse);
      expect(
        tester.widget<Expander>(expander).animationDuration,
        Duration.zero,
      );
      expect(find.byType(LessonMarkdown), findsOneWidget);
      expect(
        tester.widget<LessonMarkdown>(find.byType(LessonMarkdown)).text,
        first.prompt,
      );

      final button = find
          .descendant(of: expander, matching: find.byType(HoverButton))
          .first;
      final focus = Focus.of(
        tester.element(
          find.descendant(of: button, matching: find.byType(Text)).first,
        ),
      );
      focus.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(tester.state<ExpanderState>(expander).isExpanded, isTrue);
      expect(find.text(first.story!.world), findsOneWidget);
      expect(app.profile.exercise(first.id), ExerciseState.notStarted);
      expect(app.draftFor(first).choice, isNull);
      expect(app.draftFor(first).revealedHints, 0);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Příběh v pozadí'));
      await tester.pumpAndSettle();
      expect(tester.state<ExpanderState>(expander).isExpanded, isFalse);
      await tester.tap(find.text('Příběh v pozadí'));
      await tester.pumpAndSettle();
      expect(tester.state<ExpanderState>(expander).isExpanded, isTrue);
      selected.value = second;
      await tester.pumpAndSettle();
      expect(tester.state<ExpanderState>(expander).isExpanded, isFalse);
      expect(find.text(first.story!.world), findsNothing);
      selected.value = first;
      await tester.pumpAndSettle();
      expect(tester.state<ExpanderState>(expander).isExpanded, isFalse);
      expect(app.profile.exercise(first.id), ExerciseState.notStarted);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('dashboard is usable and contains no fabricated progress', (
    tester,
  ) async {
    await showApp(tester);
    expect(find.byKey(const ValueKey('continue-course')), findsOneWidget);
    expect(
      find.text(
        '0 z ${app.course.mainPath.length} lekcí hlavní cesty dokončeno',
      ),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('continue-course')));
    await tester.pumpAndSettle();
    expect(app.location.page, AppPage.lesson);
    expect(app.profile.recent.first, app.course.published.first.id);
    expect(find.text('Výklad'), findsOneWidget);
  });
  testWidgets('search works without accents and opens a result', (
    tester,
  ) async {
    await showApp(tester);
    await tester.tap(find.byKey(const ValueKey('course-search')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('command-search-input')),
      'promenne',
    );
    await tester.pumpAndSettle();
    final lesson = app.courseSearch.find('promenne').first;
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(app.currentLesson?.id, lesson.id);
  });
  testWidgets(
    'command search supports shortcuts, arrows, enter, escape and focus return',
    (tester) async {
      await showApp(tester);
      await tester.tap(find.byKey(const ValueKey('course-search')));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('command-search-input')), findsNothing);
      expect(FocusManager.instance.primaryFocus?.debugLabel, 'Hledat v kurzu');
      for (final modifier in [
        LogicalKeyboardKey.metaLeft,
        LogicalKeyboardKey.controlLeft,
      ]) {
        await tester.sendKeyDownEvent(modifier);
        await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
        await tester.sendKeyUpEvent(modifier);
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('command-search-input')),
          findsOneWidget,
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
      }
      await tester.tap(find.byKey(const ValueKey('course-search')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('command-search-input')),
        'java',
      );
      await tester.pumpAndSettle();
      final results = app.courseSearch.find('java');
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(app.currentLesson?.id, results[1].id);
    },
  );
  testWidgets(
    'reference link and back retain exercise draft and selected exercise',
    (tester) async {
      final lesson = app.course.lessonsById['pass-by-value']!;
      await app.openLesson(lesson);
      app.sessionFor(lesson)
        ..tab = 1
        ..exercise = 0;
      await showApp(tester);
      for (var i = 1; i <= 2; i++) {
        final button = find.text('Nápověda $i / 2');
        await tester.ensureVisible(button);
        await tester.tap(button);
        await tester.pumpAndSettle();
      }
      final link = find.byKey(const ValueKey('lesson-link-objects'));
      await tester.ensureVisible(link);
      await tester.tap(link);
      await tester.pumpAndSettle();
      expect(app.currentLesson?.id, 'objects');
      await tester.tap(find.byKey(const ValueKey('navigation-back')));
      await tester.pumpAndSettle();
      expect(app.currentLesson?.id, lesson.id);
      expect(app.sessionFor(lesson).tab, 1);
      expect(app.sessionFor(lesson).exercise, 0);
      expect(find.text('Nápověda 2'), findsOneWidget);
    },
  );
  testWidgets('reference to the current lesson can return to the exercise', (
    tester,
  ) async {
    final lesson = app.course.lessonsById['types']!;
    await app.openLesson(lesson);
    app.sessionFor(lesson).tab = 1;
    await showApp(tester);
    final answer =
        (lesson.exercises.first.validation as ChoiceValidation).options[1];
    await tester.ensureVisible(find.text(answer));
    await tester.tap(find.text(answer));
    await tester.pumpAndSettle();
    await app.openReference(lesson.id);
    await tester.pumpAndSettle();
    expect(app.sessionFor(lesson).tab, 0);
    app.back();
    await tester.pumpAndSettle();
    expect(app.sessionFor(lesson).tab, 1);
    expect(app.draftFor(lesson.exercises.first).choice, 1);
  });
  testWidgets(
    'manual exercise requires all checklist items and can be retried',
    (tester) async {
      final lesson = app.course.lessonsById['what-is-programming']!;
      final exercise = lesson.exercises.first;
      await app.openLesson(lesson);
      app.sessionFor(lesson)
        ..tab = 1
        ..exercise = 0;
      await showApp(tester);
      FilledButton finish() => tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Dokončit cvičení'),
      );
      expect(finish().onPressed, isNull);
      final checklist = (exercise.validation as ManualValidation).checklist;
      for (var i = 0; i < checklist.length; i++) {
        final check = find.byKey(ValueKey('checklist-${exercise.id}-$i'));
        await tester.ensureVisible(check);
        await tester.tap(check);
        await tester.pumpAndSettle();
      }
      expect(finish().onPressed, isNotNull);
      await tester.ensureVisible(find.text('Dokončit cvičení'));
      await tester.tap(find.text('Dokončit cvičení'));
      await tester.pumpAndSettle();
      expect(app.profile.exercise(exercise.id), ExerciseState.completed);
      await tester.ensureVisible(find.text('Procvičit znovu'));
      await tester.tap(find.text('Procvičit znovu'));
      await tester.pumpAndSettle();
      expect(app.profile.exercise(exercise.id), ExerciseState.attempted);
      expect(finish().onPressed, isNull);
    },
  );
  testWidgets('all navigation entries lead to working pages', (tester) async {
    await showApp(tester);
    for (final pair in [
      ('nav-projects', AppPage.projects),
      ('nav-progress', AppPage.progress),
      ('nav-settings', AppPage.settings),
      ('nav-library', AppPage.library),
      ('nav-home', AppPage.home),
    ]) {
      await tester.ensureVisible(find.byKey(ValueKey(pair.$1)));
      await tester.tap(find.byKey(ValueKey(pair.$1)));
      await tester.pumpAndSettle();
      expect(app.location.page, pair.$2);
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets(
    'selected course navigation opens the full course from a lesson',
    (tester) async {
      final lesson = app.course.lessonsById['types']!;
      await app.openLesson(lesson);
      app.sessionFor(lesson)
        ..tab = 1
        ..exercise = 1;
      await showApp(tester);

      await tester.tap(find.byKey(const ValueKey('nav-library')));
      await tester.pumpAndSettle();
      expect(app.location.page, AppPage.library);
      expect(app.location.group, isNull);
      expect(find.text('Všechna témata'), findsOneWidget);

      // Reselecting the overview must not add a duplicate history entry.
      await tester.tap(find.byKey(const ValueKey('nav-library')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('navigation-back')));
      await tester.pumpAndSettle();
      expect(app.currentLesson?.id, lesson.id);
      expect(app.sessionFor(lesson).tab, 1);
      expect(app.sessionFor(lesson).exercise, 1);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('selected course navigation clears a group or search', (
    tester,
  ) async {
    await showApp(tester);
    for (final open in <VoidCallback>[
      () => app.openGroup(app.course.groups.first),
      () => app.search('promenne'),
    ]) {
      open();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('nav-library')));
      await tester.pumpAndSettle();
      expect(app.location.page, AppPage.library);
      expect(app.location.group, isNull);
      expect(find.text('Všechna témata'), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });
  testWidgets('selected projects navigation returns from project detail', (
    tester,
  ) async {
    final project = app.course.projects.first;
    app.openProject(project);
    await showApp(tester);
    await tester.tap(find.byKey(const ValueKey('nav-projects')));
    await tester.pumpAndSettle();
    expect(app.location.page, AppPage.projects);
    await tester.tap(find.byKey(const ValueKey('navigation-back')));
    await tester.pumpAndSettle();
    expect(app.currentProject?.id, project.id);
    expect(tester.takeException(), isNull);
  });
  testWidgets('clicking navigation never flashes the search focus border', (
    tester,
  ) async {
    await showApp(tester);
    await tester.tap(find.byKey(const ValueKey('course-search')));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(FocusManager.instance.primaryFocus?.debugLabel, 'Hledat v kurzu');

    bool searchFocused() => tester
        .widget<FocusBorder>(
          find
              .ancestor(
                of: find.byKey(const ValueKey('course-search')),
                matching: find.byType(FocusBorder),
              )
              .first,
        )
        .focused;

    for (final key in [
      'nav-library',
      'nav-projects',
      'nav-settings',
      'nav-home',
      'nav-home',
    ]) {
      await tester.tap(
        find.byKey(ValueKey(key)),
        kind: PointerDeviceKind.mouse,
      );
      await tester.pump();
      for (var frame = 0; frame < 20; frame++) {
        expect(searchFocused(), isFalse, reason: '$key, frame $frame');
        await tester.pump(const Duration(milliseconds: 16));
      }
    }

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('command-search-input')), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(searchFocused(), isFalse);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pumpAndSettle();
    expect(searchFocused(), isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('command-search-input')), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(searchFocused(), isTrue);
  });
  testWidgets('planned lesson stays unlocked but cannot be marked complete', (
    tester,
  ) async {
    await usePlannedFilesFixture();
    await app.openLesson(app.course.lessons.firstWhere((l) => !l.isPublished));
    await showApp(tester);
    expect(find.text('Tuto lekci připravujeme'), findsOneWidget);
    expect(find.text('Označit lekci jako hotovou'), findsNothing);
    expect(find.text('Vybrat lekci'), findsOneWidget);
  });
  testWidgets(
    'reading-only lesson has no empty practice and can be completed',
    (tester) async {
      final lesson = app.course.lessonsById['how-java-works']!;
      await app.openLesson(lesson);
      // A previous visit may have selected an exercise before it was retired.
      app.sessionFor(lesson).tab = 1;
      await showApp(tester);
      expect(find.byType(TabView), findsNothing);
      expect(find.byKey(ValueKey('reading-${lesson.id}')), findsOneWidget);
      expect(find.text('Vyzkoušet cvičení'), findsNothing);
      expect(find.text('Cvičení (0)'), findsNothing);
      final complete = find.byKey(const ValueKey('complete-lesson'));
      await tester.ensureVisible(complete);
      await tester.tap(complete);
      await tester.pumpAndSettle();
      expect(app.profile.lesson(lesson.id).state, LessonState.completed);
      final next = find.byKey(const ValueKey('next-main-lesson'));
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(app.currentLesson?.id, 'jdk-and-ide');
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('hints and solutions are never revealed automatically', (
    tester,
  ) async {
    final lesson = app.course.published.first;
    await app.openLesson(lesson);
    await showApp(tester);
    await tester.tap(find.text('Cvičení (${lesson.exercises.length})'));
    await tester.pumpAndSettle();
    expect(find.text('Nápověda 1'), findsNothing);
    final hint = find
        .text('Nápověda 1 / ${lesson.exercises.first.hints.length}')
        .first;
    await tester.ensureVisible(hint);
    await tester.tap(hint);
    await tester.pumpAndSettle();
    expect(find.text('Nápověda 1'), findsOneWidget);
    final reveal = find.text('Zobrazit řešení').first;
    await tester.ensureVisible(reveal);
    await tester.tap(reveal);
    await tester.pumpAndSettle();
    expect(
      find.text('Řešení · ${lesson.exercises.first.title}'),
      findsOneWidget,
    );
    await tester.tap(find.text('Zavřít řešení'));
    await tester.pumpAndSettle();
    expect(find.text('Zavřít řešení'), findsNothing);
  });
  testWidgets('copy copies raw Java without line numbers', (tester) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map<Object?, Object?>)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    const code = 'int x = 42;\nSystem.out.println(x);\n';
    await tester.pumpWidget(
      const FluentApp(
        home: NavigationView(
          content: Center(
            child: SizedBox(width: 600, child: CodeBlock(code: code)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kopírovat'));
    await tester.pump();
    expect(copied, code);
    await tester.pump(const Duration(seconds: 3));
  });
  for (final mode in ['light', 'dark']) {
    testWidgets(
      '$mode theme at narrow window and 150% text has no layout errors',
      (tester) async {
        await app.preference('theme', mode);
        await app.preference('uiScale', '150');
        await showApp(tester, size: const Size(900, 900));
        expect(tester.takeException(), isNull);
        await tester.tap(find.byKey(const ValueKey('nav-settings')));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets(
    'all published lessons and exercises fit a small desktop at 160% text',
    (tester) async {
      await app.preference('uiScale', '160');
      await showApp(tester, size: const Size(840, 600));
      for (final lesson in app.course.published) {
        await app.openLesson(lesson);
        app.sessionFor(lesson).tab = 0;
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: lesson.id);
        for (var i = 0; i < lesson.exercises.length; i++) {
          app.sessionFor(lesson)
            ..tab = 1
            ..exercise = i;
          app.go(
            PageLocation(AppPage.lesson, lessonId: lesson.id),
            remember: false,
          );
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: lesson.exercises[i].id,
          );
        }
      }
      app.go(const PageLocation(AppPage.library));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final clipped = <String>[];
      for (final element in find.byType(RichText).evaluate()) {
        final render = element.renderObject;
        if (render is RenderParagraph && render.didExceedMaxLines) {
          clipped.add(render.text.toPlainText());
        }
      }
      expect(
        clipped,
        isEmpty,
        reason: 'Lesson titles should wrap without clipping.',
      );
      await tester.tap(find.byKey(const ValueKey('course-search')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('command-search-input')),
        'return',
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
    },
  );
  testWidgets('inline lesson links scale once with the surrounding paragraph', (
    tester,
  ) async {
    await app.openLesson(app.course.lessonsById['variables']!);
    await showApp(tester);
    final linkText = find.descendant(
      of: find.byKey(const ValueKey('lesson-link-language-and-algorithms')),
      matching: find.byType(Text),
    );
    final originalHeight = tester.getRect(linkText).height;
    await app.preference('uiScale', '160');
    await tester.pumpAndSettle();
    expect(tester.getRect(linkText).height, closeTo(originalHeight * 1.6, 1));
    expect(tester.takeException(), isNull);
  });
  testWidgets('reading reference and back open each lesson at the top', (
    tester,
  ) async {
    await app.openLesson(app.course.lessonsById['variables']!);
    await showApp(tester, size: const Size(840, 600));
    final reference = find.byKey(
      const ValueKey('lesson-link-language-and-algorithms'),
    );
    await tester.ensureVisible(reference);
    await tester.pump();
    ScrollableState reader() => tester.state<ScrollableState>(
      find
          .descendant(
            of: find.byKey(const ValueKey('reading-variables')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    final offset = reader().position.pixels;
    expect(offset, greaterThan(100));
    await tester.tap(reference);
    await tester.pumpAndSettle();
    expect(app.currentLesson?.id, 'language-and-algorithms');
    await tester.tap(find.byKey(const ValueKey('navigation-back')));
    await tester.pumpAndSettle();
    expect(app.currentLesson?.id, 'variables');
    expect(reader().position.pixels, 0);
  });
  testWidgets('opening or reopening a lesson starts at the top', (
    tester,
  ) async {
    final lesson = app.course.lessonsById['variables']!;
    await app.saveOffset(lesson.id, 1200);
    await app.openLesson(lesson);
    await showApp(tester, size: const Size(840, 600));
    ScrollableState reader() => tester.state<ScrollableState>(
      find
          .descendant(
            of: find.byKey(ValueKey('reading-${lesson.id}')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(reader().position.pixels, 0);
    reader().position.jumpTo(reader().position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(reader().position.pixels, greaterThan(100));

    await app.openLesson(lesson);
    await tester.pumpAndSettle();
    expect(reader().position.pixels, 0);
    reader().position.jumpTo(reader().position.maxScrollExtent);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('nav-home')));
    await tester.pumpAndSettle();
    app.sessionFor(lesson).tab = 1;
    await app.openLesson(lesson);
    await tester.pumpAndSettle();
    expect(app.sessionFor(lesson).tab, 0);
    expect(reader().position.pixels, 0);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'expanded settings and projects fit a small desktop at 160% text',
    (tester) async {
      await app.preference('uiScale', '160');
      app.go(const PageLocation(AppPage.settings));
      await showApp(tester, size: const Size(840, 600));
      for (final label in [
        'Java a editor',
        'Zadat cesty ručně',
        'Soubory cvičení a spouštění',
        'Data a zálohy',
        'O aplikaci',
      ]) {
        final header = find.text(label);
        await tester.ensureVisible(header);
        await tester.tap(header);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: label);
      }
      for (final project in app.course.projects) {
        app.openProject(project);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: project.id);
      }
    },
  );
  testWidgets(
    'favorite and completion are persisted without forcing exercises',
    (tester) async {
      final lesson = app.course.published.first;
      await app.openLesson(lesson);
      await showApp(tester);
      await tester.tap(find.byKey(const ValueKey('favorite-lesson')));
      await tester.pumpAndSettle();
      expect(app.profile.lesson(lesson.id).favorite, isTrue);
      final button = find.text('Označit lekci jako hotovou');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(app.profile.lesson(lesson.id).state, LessonState.completed);
      expect(
        lesson.exercises.every(
          (e) => app.profile.exercise(e.id) == ExerciseState.notStarted,
        ),
        isTrue,
      );
    },
  );
  testWidgets(
    'optional detour returns to the main path without affecting progress',
    (tester) async {
      await app.openLesson(app.course.lessonsById['what-is-programming']!);
      await showApp(tester);
      final optional = find.text('Dobrovolně navíc');
      await tester.ensureVisible(optional);
      await tester.tap(optional);
      await tester.pumpAndSettle();
      final row = find.byKey(const ValueKey('lesson-learning-routine'));
      await tester.ensureVisible(row);
      await tester.tap(row);
      await tester.pumpAndSettle();
      expect(app.currentLesson?.optional, isTrue);
      final complete = find.byKey(const ValueKey('complete-lesson'));
      await tester.ensureVisible(complete);
      await tester.tap(complete);
      await tester.pumpAndSettle();
      expect(
        app.profile.lesson('learning-routine').state,
        LessonState.completed,
      );
      expect(app.profile.fraction(app.course), 0);
      final next = find.byKey(const ValueKey('next-main-lesson'));
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(app.currentLesson?.id, 'how-java-works');
      await app.openLesson(app.course.lessonsById['short-assignments']!);
      await tester.pumpAndSettle();
      final nextTip = find.byKey(const ValueKey('next-optional-lesson'));
      await tester.ensureVisible(nextTip);
      await tester.tap(nextTip);
      await tester.pumpAndSettle();
      expect(app.currentLesson?.id, 'text-formatting');
      expect(app.profile.fraction(app.course), 0);
    },
  );
  testWidgets(
    'course projects appear in order and allow continuation without completion',
    (tester) async {
      app.openGroup('Základy Javy');
      await showApp(tester);
      final project = find.byKey(const ValueKey('project-project-guessing'));
      expect(project, findsOneWidget);
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('lesson-while-loops'))).dy,
        lessThan(tester.getTopLeft(project).dy),
      );
      expect(
        tester.getTopLeft(project).dy,
        lessThan(
          tester.getTopLeft(find.byKey(const ValueKey('lesson-methods'))).dy,
        ),
      );
      await tester.ensureVisible(project);
      await tester.tap(project);
      await tester.pumpAndSettle();
      expect(app.currentProject?.id, 'project-guessing');
      final next = find.byKey(const ValueKey('continue-after-project'));
      await tester.ensureVisible(next);
      await tester.tap(next);
      await tester.pumpAndSettle();
      expect(app.currentLesson?.id, 'methods');
      expect(
        app.profile.exercise('ex-project-guessing'),
        ExerciseState.notStarted,
      );
      app.openGroup('Soubory a data');
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('project-project-expenses')),
        findsOneWidget,
      );
      expect(find.text('Tato témata ještě připravujeme'), findsNothing);
      expect(
        find.byKey(const ValueKey('lesson-exceptions-overview')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('project-project-studydesk')),
        findsNothing,
      );
      final expensesProject = find.byKey(
        const ValueKey('project-project-expenses'),
      );
      await tester.ensureVisible(expensesProject);
      await tester.tap(expensesProject);
      await tester.pumpAndSettle();
      expect(find.text('Nejdřív navazující lekce'), findsNothing);
    },
  );
  testWidgets(
    'the whole course shows all lessons and projects without a planned toggle',
    (tester) async {
      await usePlannedFilesFixture();
      app.openGroup(null);
      await showApp(tester, size: const Size(840, 600));
      await app.preference('uiScale', '160');
      await tester.pumpAndSettle();
      expect(find.text('Ukázat připravovaná témata'), findsNothing);
      for (final lesson in app.course.lessons) {
        expect(find.byKey(ValueKey('lesson-${lesson.id}')), findsOneWidget);
      }
      double? previousY;
      for (final project in app.course.projects) {
        final row = find.byKey(ValueKey('project-${project.id}'));
        expect(row, findsOneWidget, reason: project.id);
        final y = tester.getTopLeft(row).dy;
        if (previousY != null) expect(y, greaterThan(previousY));
        previousY = y;
        expect(
          tester
              .getTopLeft(find.byKey(ValueKey('lesson-${project.afterLesson}')))
              .dy,
          lessThan(y),
          reason: project.id,
        );
      }
      expect(tester.takeException(), isNull);
      app.openGroup('Kolekce');
      await tester.pumpAndSettle();
      expect(find.text('Tato témata ještě připravujeme'), findsNothing);
      expect(
        find.byKey(const ValueKey('lesson-collections-overview')),
        findsOneWidget,
      );
      app.go(const PageLocation(AppPage.favorites));
      await tester.pumpAndSettle();
      expect(find.text('Zatím žádné oblíbené'), findsOneWidget);
      for (final project in app.course.projects) {
        expect(find.byKey(ValueKey('project-${project.id}')), findsNothing);
      }
    },
  );
  testWidgets(
    'the last exercise also offers the following project and main lesson',
    (tester) async {
      final lesson = app.course.lessonsById['while-loops']!;
      await app.openLesson(lesson);
      app.sessionFor(lesson)
        ..tab = 1
        ..exercise = lesson.exercises.length - 1;
      await showApp(tester);
      final project = find.byKey(const ValueKey('project-project-guessing'));
      await tester.ensureVisible(project);
      await tester.tap(project);
      await tester.pumpAndSettle();
      expect(app.currentProject?.id, 'project-guessing');
    },
  );
}
