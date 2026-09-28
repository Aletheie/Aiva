import 'package:fluent_ui/fluent_ui.dart';
import '../../app/app_controller.dart';
import '../../domain/course.dart';
import 'lesson_row.dart';
import 'project_row.dart';
import 'surfaces.dart';

class LessonContinuation extends StatelessWidget {
  const LessonContinuation({
    super.key,
    required this.controller,
    required this.lesson,
  });
  final AppController controller;
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final next = controller.course.nextPublished(lesson.id);
    final extras = controller.course.optionalAfter(lesson.id);
    final projects = controller.course.projectsAfter(lesson.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (projects.isNotEmpty) ...[
          const SectionTitle(
            'Zkus malý projekt',
            subtitle: 'Můžeš začít teď nebo se k němu vrátit později.',
          ),
          for (final project in projects)
            ProjectRow(controller: controller, project: project),
        ],
        if (extras.isNotEmpty) ...[
          const SizedBox(height: 20),
          if (lesson.optional)
            ListTile(
              key: const ValueKey('next-optional-lesson'),
              title: const Text('Další dobrovolná lekce'),
              subtitle: Text(extras.first.title),
              trailing: const ExcludeSemantics(
                child: Icon(FluentIcons.chevron_right, size: 14),
              ),
              onPressed: () => controller.openLesson(extras.first),
            )
          else
            Expander(
              key: ValueKey('optional-after-${lesson.id}'),
              header: const Text('Dobrovolně navíc'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Krátké odbočky. Pro další lekci je nepotřebuješ.',
                  ),
                  const SizedBox(height: 8),
                  for (final extra in extras)
                    LessonRow(controller: controller, lesson: extra),
                ],
              ),
            ),
        ],
        const SizedBox(height: 20),
        if (next != null)
          ListTile(
            key: const ValueKey('next-main-lesson'),
            title: Text(
              lesson.optional ? 'Zpět na hlavní cestu' : 'Pokračovat v kurzu',
            ),
            subtitle: Text(next.title),
            trailing: const ExcludeSemantics(
              child: Icon(FluentIcons.chevron_right, size: 14),
            ),
            onPressed: () => controller.openLesson(next),
          )
        else ...[
          if (!lesson.optional || extras.isEmpty)
            Text(
              lesson.optional
                  ? 'Tady dobrovolná odbočka končí.'
                  : 'To je poslední hotová lekce hlavní cesty. Další témata připravujeme.',
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: HyperlinkButton(
              onPressed: () => controller.openGroup(null),
              child: const Text('Zpět do celého kurzu'),
            ),
          ),
        ],
      ],
    );
  }
}
