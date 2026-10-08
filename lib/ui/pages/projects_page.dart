import 'package:fluent_ui/fluent_ui.dart';
import '../../app/app_controller.dart';
import '../../domain/course.dart';
import '../../domain/profile.dart';
import '../components/exercise_studio.dart';
import '../design.dart';
import '../components/exercise_card.dart';
import '../components/project_row.dart';
import '../components/surfaces.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key, required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) => PageScroll(
    children: [
      const PageTitle(
        title: 'Projekty',
        subtitle:
            'Dobrovolné zastávky v kurzu. Každý projekt můžeš dělat po částech.',
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: HyperlinkButton(
          onPressed: () => controller.openGroup(null),
          child: const Text('Ukázat projekty mezi lekcemi'),
        ),
      ),
      for (final project in controller.course.projects)
        ProjectRow(controller: controller, project: project),
    ],
  );
}

class ProjectPage extends StatelessWidget {
  const ProjectPage({
    super.key,
    required this.controller,
    required this.project,
  });
  final AppController controller;
  final CourseProject project;
  @override
  Widget build(BuildContext context) {
    if (controller.profile.exerciseEditorMode == ExerciseEditorMode.embedded &&
        project.exercise.starter != null) {
      return ExerciseStudio(
        key: ValueKey('studio-${project.exercise.id}'),
        controller: controller,
        exercise: project.exercise,
        courseTitle: 'Dobrovolný projekt · ${project.title}',
        onReading: () => controller.openGroup(null),
      );
    }
    final course = controller.course;
    final nextLesson = course.nextPublished(project.afterLesson);
    final siblings = course.projectsAfter(project.afterLesson);
    final index = siblings.indexOf(project);
    final nextProject = index >= 0 && index + 1 < siblings.length
        ? siblings[index + 1]
        : null;
    return PageScroll(
      maxWidth: Design.readingWidth,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: HyperlinkButton(
            onPressed: () => controller.openGroup(null),
            child: const Text('Celý kurz'),
          ),
        ),
        const SizedBox(height: 16),
        PageTitle(title: project.title, subtitle: project.subtitle),
        Text(
          'Dobrovolný projekt · přibližně ${project.estimatedMinutes} min celkem. Rozděl si ho do více dní.',
        ),
        const SizedBox(height: 8),
        Text(
          'V kurzu navazuje na: ${course.lessonsById[project.afterLesson]!.title}.',
        ),
        if (!course.projectIsAvailable(project)) ...[
          const SizedBox(height: 16),
          const InfoBar(
            title: Text('Nejdřív navazující lekce'),
            content: Text(
              'Zadání si můžeš prohlédnout už teď. Některé potřebné lekce ještě připravujeme; projekt zatím počítá se samostatným studiem.',
            ),
            severity: InfoBarSeverity.info,
          ),
        ],
        const SizedBox(height: 16),
        Expander(
          header: const Text('Co si předem zopakovat'),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final id in project.prerequisites)
                HyperlinkButton(
                  onPressed: () => controller.openReference(id),
                  child: Text(controller.course.lessonsById[id]!.title),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ExerciseCard(
          key: ValueKey(project.exercise.id),
          controller: controller,
          exercise: project.exercise,
          showHeading: false,
        ),
        const SectionTitle('Kam dál'),
        if (nextProject != null)
          ProjectRow(controller: controller, project: nextProject),
        const Text(
          'K projektu se můžeš kdykoli vrátit. Pro pokračování ho nemusíš dokončit.',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (nextLesson != null)
              FilledButton(
                key: const ValueKey('continue-after-project'),
                onPressed: () => controller.openLesson(nextLesson),
                child: Text('Pokračovat: ${nextLesson.title}'),
              ),
            Button(
              onPressed: () => controller.openGroup(null),
              child: const Text('Zpět do celého kurzu'),
            ),
          ],
        ),
      ],
    );
  }
}
