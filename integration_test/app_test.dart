import 'dart:io';
import 'dart:ui' as ui;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:aiva/app/app_controller.dart';
import 'package:aiva/app/aiva_app.dart';
import 'package:aiva/main.dart';
import 'package:aiva/domain/course.dart';
import 'package:aiva/services/workspace_service.dart';
import 'package:aiva/ui/components/exercise_story.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'native startup, navigation, persistence, dark mode and screenshots',
    (tester) async {
      final profile = await Directory.systemTemp.createTemp(
        'aiva-native-test-',
      );
      final app = await loadApplication(profileOverride: profile.path);
      await app.preference('reducedMotion', 'yes');
      final capture = GlobalKey();
      Future<void> screenshot(String name) async {
        final destination =
            Platform.environment['AIVA_SCREENSHOT_DIR'] ??
            const String.fromEnvironment('AIVA_SCREENSHOT_DIR');
        if (destination.isEmpty) return;
        await tester.pumpAndSettle();
        final boundary =
            capture.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 1);
        try {
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final file = File('$destination/$name.png');
          await file.parent.create(recursive: true);
          await file.writeAsBytes(
            bytes!.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
          );
        } finally {
          image.dispose();
        }
      }

      try {
        await tester.pumpWidget(
          RepaintBoundary(
            key: capture,
            child: AivaApp(controller: app),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('continue-course')), findsOneWidget);
        // Check starter files from the app bundle, including .gitignore files.
        var prepared = 0;
        for (final exercise in app.course.exercises.where(
          (e) => e.starter != null,
        )) {
          final workspace = await app.workspaces.prepare(
            '${profile.path}/workspaces',
            exercise,
          );
          expect(workspace.created, isTrue, reason: exercise.id);
          final files = await app.source.filesUnder(exercise.starter!);
          for (final file in files) {
            final relative = file.substring(exercise.starter!.length + 1);
            expect(
              await File('${workspace.path}/$relative').readAsBytes(),
              await app.source.readBytes(file),
              reason: '${exercise.id}: $relative',
            );
          }
          if (exercise.validation is OutputValidation) {
            expect(
              await WorkspaceService.javaSources(workspace.path),
              isNotEmpty,
              reason: exercise.id,
            );
          }
          prepared++;
        }
        debugPrint('Prepared $prepared bundled exercise workspaces.');
        if (Platform.isMacOS) {
          final window = await const MethodChannel(
            'aiva/window',
          ).invokeMapMethod<String, Object?>('windowInfo');
          expect(window?['fullSizeContent'], isTrue);
          expect(window?['titleHidden'], isTrue);
          expect(window?['transparentTitlebar'], isTrue);
          debugPrint('Native window controls: ${window?['buttons']}');
        }
        await screenshot('01-home-light');
        await tester.tap(find.byKey(const ValueKey('continue-course')));
        await tester.pumpAndSettle();
        expect(app.currentLesson, isNotNull);
        await screenshot('02-lesson-light');
        final lesson = app.currentLesson!;
        await app.completeLesson(lesson, true);
        await app.toggleFavorite(lesson);
        expect(
          (await app.store.load()).lesson(lesson.id).state,
          LessonState.completed,
        );
        await app.preference('theme', 'dark');
        await tester.pumpAndSettle();
        await screenshot('03-lesson-dark');
        await tester.tap(find.text('Cvičení (${lesson.exercises.length})'));
        await tester.pumpAndSettle();
        await screenshot('04-exercises-dark');
        final storyPanel = find.descendant(
          of: find.byType(ExerciseStoryPanel),
          matching: find.byType(Expander),
        );
        expect(tester.state<ExpanderState>(storyPanel).isExpanded, isFalse);
        final exerciseState = app.profile.exercise(lesson.exercises.first.id);
        await tester.tap(find.text('Příběh v pozadí'));
        await tester.pumpAndSettle();
        expect(tester.state<ExpanderState>(storyPanel).isExpanded, isTrue);
        expect(find.text(lesson.exercises.first.story!.world), findsOneWidget);
        expect(app.profile.exercise(lesson.exercises.first.id), exerciseState);
        await screenshot('22-story-expanded-dark');
        await tester.tap(find.text('Příběh v pozadí'));
        await tester.pumpAndSettle();
        expect(tester.state<ExpanderState>(storyPanel).isExpanded, isFalse);
        await tester.ensureVisible(find.byKey(const ValueKey('nav-projects')));
        await tester.tap(find.byKey(const ValueKey('nav-projects')));
        await tester.pumpAndSettle();
        expect(app.location.page, AppPage.projects);
        await screenshot('05-projects-dark');
        await tester.tap(find.byKey(const ValueKey('course-search')));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('command-search-input')),
          'variables',
        );
        await tester.pumpAndSettle();
        await screenshot('06-search-dark');
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        await app.preference('theme', 'light');
        await app.openLesson(app.course.lessonsById['variables']!);
        await tester.pumpAndSettle();
        await screenshot('07-variables-light');
        final optional = find.text(
          'Dobrovolně · Pod povrch: kdy se výsledek přepočítá',
        );
        await tester.ensureVisible(optional);
        await tester.tap(optional);
        await tester.pumpAndSettle();
        expect(
          tester
              .state<ExpanderState>(
                find.ancestor(of: optional, matching: find.byType(Expander)),
              )
              .isExpanded,
          isTrue,
        );
        await screenshot('19-optional-depth-light');
        await app.openLesson(app.course.lessonsById['sql-and-jdbc']!);
        await tester.pumpAndSettle();
        await screenshot('24-sql-jdbc-light');
        await app.preference('uiScale', '160');
        app.go(const PageLocation(AppPage.settings));
        await tester.pumpAndSettle();
        await screenshot('08-settings-large-text');
        await tester.tap(find.byKey(const ValueKey('course-search')));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('command-search-input')),
          'return',
        );
        await tester.pumpAndSettle();
        await screenshot('09-search-large-text');
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        await app.preference('theme', 'light');
        await app.preference('uiScale', '100');
        app.openGroup('Základy Javy');
        await tester.pumpAndSettle();
        final projectStop = find.byKey(
          const ValueKey('project-project-guessing'),
        );
        await tester.ensureVisible(projectStop);
        await screenshot('10-course-project-stop');
        await tester.tap(projectStop);
        await tester.pumpAndSettle();
        await screenshot('11-project-stages');
        app.openGroup('Vychytávky');
        await tester.pumpAndSettle();
        await screenshot('12-optional-tips-chapter');
        await app.openLesson(app.course.lessonsById['text-formatting']!);
        await tester.pumpAndSettle();
        expect(find.byType(TabView), findsNothing);
        expect(find.text('Vyzkoušet cvičení'), findsNothing);
        await screenshot('13-optional-tip');
        await app.preference('uiScale', '160');
        app.openProject(app.course.projects.first);
        await tester.pumpAndSettle();
        await screenshot('14-project-large-text');
        await tester.binding.setSurfaceSize(const Size(840, 600));
        await app.openLesson(app.course.lessonsById['variables']!);
        await tester.pumpAndSettle();
        await screenshot('15-lesson-small-large-text');
        await tester.tap(find.byKey(const ValueKey('course-search')));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(const ValueKey('command-search-input')),
          'return',
        );
        await tester.pumpAndSettle();
        await screenshot('16-search-small-large-text');
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        final practice = app.course.lessonsById['variables']!;
        await app.openLesson(practice);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cvičení (${practice.exercises.length})'));
        await tester.pumpAndSettle();
        final selector = find.byKey(const ValueKey('exercise-selector'));
        expect(selector, findsOneWidget);
        expect(find.text(practice.exercises.first.title), findsOneWidget);
        await screenshot('17-meaningful-exercise-large-text');
        final missionIndex = practice.exercises.indexWhere(
          (exercise) => exercise.id.startsWith('ex-mission-'),
        );
        expect(missionIndex, greaterThanOrEqualTo(0));
        final mission = practice.exercises[missionIndex];
        await tester.ensureVisible(selector);
        await tester.tap(selector);
        await tester.pumpAndSettle();
        await tester.tap(
          find
              .text(
                '${missionIndex + 1}. ${mission.title}'
                '${mission.difficulty == Difficulty.challenge ? ' · Výzva' : ''}',
              )
              .last,
        );
        await tester.pumpAndSettle();
        expect(find.byKey(ValueKey(mission.id)), findsOneWidget);
        expect(find.text(mission.title), findsOneWidget);
        await screenshot('21-expanded-repair-large-text');
        expect(tester.state<ExpanderState>(storyPanel).isExpanded, isFalse);
        await tester.ensureVisible(find.text('Příběh v pozadí'));
        await tester.tap(find.text('Příběh v pozadí'));
        await tester.pumpAndSettle();
        expect(tester.state<ExpanderState>(storyPanel).isExpanded, isTrue);
        expect(find.text(mission.story!.world), findsOneWidget);
        await screenshot('23-story-expanded-large-text');
        final reading = app.course.lessonsById['how-java-works']!;
        await app.openLesson(reading);
        app.sessionFor(reading).tab = 1;
        await tester.pumpAndSettle();
        expect(find.byType(TabView), findsNothing);
        await screenshot('18-reading-without-exercises');
        final bytecode = find.text(
          'Dobrovolně · Pod povrch: prohlédni si bajtkód',
        );
        await tester.ensureVisible(bytecode);
        await tester.tap(bytecode);
        await tester.pumpAndSettle();
        await screenshot('20-optional-depth-large-text');
        expect(tester.takeException(), isNull);
      } finally {
        await tester.binding.setSurfaceSize(null);
        await tester.pumpWidget(const SizedBox.shrink());
        app.dispose();
        // Wait for any final queued reader-position write before removing the fixture.
        await app.store.load();
        await profile.delete(recursive: true);
      }
    },
  );
}
