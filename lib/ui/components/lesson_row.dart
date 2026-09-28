import 'package:fluent_ui/fluent_ui.dart';
import '../../app/app_controller.dart';
import '../../domain/course.dart';
import '../design.dart';

class LessonRow extends StatelessWidget {
  const LessonRow({super.key, required this.controller, required this.lesson});
  final AppController controller;
  final Lesson lesson;
  @override
  Widget build(BuildContext context) {
    final progress = controller.profile.lesson(lesson.id);
    final completed = progress.state == LessonState.completed;
    final status = !lesson.isPublished
        ? 'Připravujeme'
        : completed
        ? 'Dokončeno'
        : progress.skipped
        ? 'Odloženo'
        : '${lesson.estimatedMinutes} min';
    return ListTile(
      key: ValueKey('lesson-${lesson.id}'),
      onPressed: () => controller.openLesson(lesson),
      leading: ExcludeSemantics(
        child: Icon(
          completed ? FluentIcons.completed : FluentIcons.reading_mode,
          size: 18,
          color: completed ? Design.accentFor(context) : Design.muted(context),
        ),
      ),
      title: Text(
        lesson.optional ? 'Dobrovolně · ${lesson.title}' : lesson.title,
      ),
      subtitle: Text('${lesson.subtitle} · $status'),
      trailing: ExcludeSemantics(
        child: Icon(
          progress.favorite
              ? FluentIcons.favorite_star_fill
              : FluentIcons.chevron_right,
          size: progress.favorite ? 16 : 12,
          color: Design.muted(context),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }
}
