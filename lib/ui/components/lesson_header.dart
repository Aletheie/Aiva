import 'package:fluent_ui/fluent_ui.dart';
import '../../app/app_controller.dart';
import '../../domain/course.dart';
import '../design.dart';

class LessonHeader extends StatelessWidget {
  const LessonHeader({
    super.key,
    required this.controller,
    required this.lesson,
  });
  final AppController controller;
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final progress = controller.profile.lesson(lesson.id);
    final chapter = controller.course.chaptersById[lesson.chapter]!;
    final position = controller.course.mainPath.indexOf(lesson) + 1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HyperlinkButton(
            onPressed: () => controller.openGroup(chapter.group),
            child: Text(chapter.group),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    lesson.title,
                    style: FluentTheme.of(context).typography.title,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Tooltip(
                message: progress.favorite
                    ? 'Odebrat z oblíbených'
                    : 'Přidat do oblíbených',
                child: ToggleButton(
                  key: const ValueKey('favorite-lesson'),
                  checked: progress.favorite,
                  onChanged: (_) => controller.toggleFavorite(lesson),
                  child: Semantics(
                    label: progress.favorite
                        ? 'Odebrat z oblíbených'
                        : 'Přidat do oblíbených',
                    child: Icon(
                      progress.favorite
                          ? FluentIcons.favorite_star_fill
                          : FluentIcons.favorite_star,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            lesson.subtitle,
            style: TextStyle(color: Design.muted(context), height: 1.5),
          ),
          const SizedBox(height: 12),
          Text(
            lesson.isPublished
                ? '${lesson.optional ? 'Dobrovolná mezisekce' : 'Krok $position z ${controller.course.mainPath.length}'}'
                      ' · ${lesson.estimatedMinutes} min · ${progress.state == LessonState.completed ? 'Dokončeno' : lesson.difficulty.label}'
                : 'Připravujeme',
            style: FluentTheme.of(
              context,
            ).typography.caption?.copyWith(color: Design.muted(context)),
          ),
          if (lesson.optional) ...[
            const SizedBox(height: 8),
            const Text(
              'Čti, pokud tě téma zajímá. K dokončení hlavní cesty tuto mezisekci nepotřebuješ.',
            ),
          ],
        ],
      ),
    );
  }
}
