import 'package:fluent_ui/fluent_ui.dart';
import '../../app/app_controller.dart';
import '../../domain/course.dart';
import '../components/lesson_row.dart';
import '../components/surfaces.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key, required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) {
    final app = controller;
    final exercises = app.course.exercises.toList();
    final completed = app.profile.completedCount(app.course);
    final doneExercises = exercises
        .where((e) => app.profile.exercise(e.id) == ExerciseState.completed)
        .length;
    final skipped = app.course.lessons
        .where((l) => app.profile.lesson(l.id).skipped)
        .toList();
    final extraCount = app.course.published
        .where(
          (l) =>
              l.optional &&
              app.profile.lesson(l.id).state == LessonState.completed,
        )
        .length;
    return PageScroll(
      children: [
        const PageTitle(
          title: 'Můj postup',
          subtitle: 'Dokončené lekce, cvičení a témata odložená na později.',
        ),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '$completed z ${app.course.mainPath.length} lekcí hlavní cesty dokončeno',
                style: FluentTheme.of(context).typography.subtitle,
              ),
              const SizedBox(height: 16),
              ProgressBar(value: app.profile.fraction(app.course) * 100),
              const SizedBox(height: 16),
              Text(
                '$doneExercises z ${exercises.length} cvičení a projektů dokončeno',
              ),
              const SizedBox(height: 8),
              Text(
                'Dobrovolné mezisekce: $extraCount dokončeno. Do hlavní cesty se nepočítají.',
              ),
            ],
          ),
        ),
        const SectionTitle('Oblasti kurzu'),
        for (final group in app.course.groups)
          if (app.course
              .inGroup(group)
              .any((l) => l.isPublished && !l.optional))
            _GroupProgress(app, group),
        if (skipped.isNotEmpty) ...[
          const SectionTitle('Na později'),
          for (final lesson in skipped)
            LessonRow(controller: app, lesson: lesson),
        ],
      ],
    );
  }
}

class _GroupProgress extends StatelessWidget {
  const _GroupProgress(this.app, this.group);
  final AppController app;
  final String group;
  @override
  Widget build(BuildContext context) {
    final lessons = app.course
        .inGroup(group)
        .where((l) => l.isPublished && !l.optional)
        .toList();
    final count = lessons
        .where((l) => app.profile.lesson(l.id).state == LessonState.completed)
        .length;
    return ListTile(
      title: Text(group),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ProgressBar(
          value: count / lessons.length * 100,
          semanticLabel: '$group: $count z ${lessons.length} lekcí',
        ),
      ),
      trailing: Text('$count / ${lessons.length}'),
      onPressed: () => app.openGroup(group),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    );
  }
}
