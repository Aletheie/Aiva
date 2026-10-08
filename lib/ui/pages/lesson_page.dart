import 'package:fluent_ui/fluent_ui.dart';
import '../../app/app_controller.dart';
import '../../domain/course.dart';
import '../../domain/profile.dart';
import '../components/exercise_studio.dart';
import '../components/lesson_header.dart';
import '../components/lesson_continuation.dart';
import '../components/lesson_reading.dart';
import '../components/exercise_card.dart';
import '../components/surfaces.dart';
import '../design.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.controller, required this.lesson});
  final AppController controller;
  final Lesson lesson;
  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  AppController get app => widget.controller;
  Lesson get lesson => widget.lesson;
  late final List<Tab> _tabs;

  @override
  void initState() {
    super.initState();
    // fluent_ui keys tab bodies by Tab identity. Keep those instances stable
    // while controller notifications update each body independently.
    _tabs = [
      Tab(
        text: const Text('Výklad'),
        semanticLabel: 'Výklad lekce',
        icon: const Icon(FluentIcons.reading_mode, size: 16),
        body: AnimatedBuilder(
          animation: app,
          builder: (context, _) => LessonReading(
            key: ValueKey('reading-${lesson.id}'),
            controller: app,
            lesson: lesson,
            onExercises: () => _tab(1),
          ),
        ),
      ),
      if (lesson.exercises.isNotEmpty)
        Tab(
          text: Text('Cvičení (${lesson.exercises.length})'),
          semanticLabel: 'Cvičení k lekci',
          icon: const Icon(FluentIcons.code, size: 16),
          body: AnimatedBuilder(
            animation: app,
            builder: (context, _) => _Exercises(
              controller: app,
              lesson: lesson,
              onReading: () => _tab(0),
            ),
          ),
        ),
    ];
  }

  void _tab(int value) => setState(() => app.sessionFor(lesson).tab = value);

  @override
  Widget build(BuildContext context) {
    if (!lesson.isPublished) {
      return PageScroll(
        maxWidth: Design.readingWidth,
        children: [
          LessonHeader(controller: app, lesson: lesson),
          EmptyState(
            title: 'Tuto lekci připravujeme',
            message:
                'Zatím je k dispozici jen její místo v osnově. Vyber si některou z hotových lekcí.',
            action: Button(
              onPressed: () => app.openGroup(null),
              child: const Text('Vybrat lekci'),
            ),
          ),
        ],
      );
    }
    if (lesson.exercises.isEmpty) {
      return LessonReading(
        key: ValueKey('reading-${lesson.id}'),
        controller: app,
        lesson: lesson,
      );
    }
    final session = app.sessionFor(lesson);
    return TabView(
      currentIndex: session.tab,
      onChanged: _tab,
      tabWidthBehavior: TabWidthBehavior.sizeToContent,
      tabs: _tabs,
    );
  }
}

class _Exercises extends StatefulWidget {
  const _Exercises({
    required this.controller,
    required this.lesson,
    required this.onReading,
  });
  final AppController controller;
  final Lesson lesson;
  final VoidCallback onReading;
  @override
  State<_Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<_Exercises> {
  final _scroll = ScrollController();
  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _select(int index) {
    setState(
      () => widget.controller.sessionFor(widget.lesson).exercise = index,
    );
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.controller;
    final lesson = widget.lesson;
    final index = app
        .sessionFor(lesson)
        .exercise
        .clamp(0, lesson.exercises.length - 1);
    final exercise = lesson.exercises[index];
    if (app.profile.exerciseEditorMode == ExerciseEditorMode.embedded &&
        exercise.starter != null) {
      return ExerciseStudio(
        key: ValueKey('studio-${exercise.id}'),
        controller: app,
        exercise: exercise,
        courseTitle: lesson.title,
        exercises: lesson.exercises,
        exerciseIndex: index,
        onSelectExercise: _select,
        onReading: widget.onReading,
      );
    }
    return PageScroll(
      controller: _scroll,
      maxWidth: Design.readingWidth,
      children: [
        LessonHeader(controller: app, lesson: lesson),
        if (lesson.exercises.length > 1) ...[
          InfoLabel(
            label: 'Vyber cvičení',
            child: ComboBox<int>(
              key: const ValueKey('exercise-selector'),
              isExpanded: true,
              value: index,
              items: [
                for (var i = 0; i < lesson.exercises.length; i++)
                  ComboBoxItem(
                    value: i,
                    child: Text(
                      '${i + 1}. ${lesson.exercises[i].title}'
                      '${lesson.exercises[i].difficulty == Difficulty.challenge ? ' · Výzva' : ''}'
                      '${app.profile.exercise(lesson.exercises[i].id) == ExerciseState.completed ? ' · Hotovo' : ''}',
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) _select(value);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
        ExerciseCard(
          key: ValueKey(exercise.id),
          controller: app,
          exercise: exercise,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (index > 0)
              Button(
                onPressed: () => _select(index - 1),
                child: const Text('Předchozí cvičení'),
              ),
            if (index + 1 < lesson.exercises.length)
              Button(
                onPressed: () => _select(index + 1),
                child: const Text('Další cvičení'),
              ),
          ],
        ),
        if (index + 1 == lesson.exercises.length)
          LessonContinuation(controller: app, lesson: lesson),
      ],
    );
  }
}
