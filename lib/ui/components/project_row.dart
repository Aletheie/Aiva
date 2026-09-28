import 'package:fluent_ui/fluent_ui.dart';
import '../../app/app_controller.dart';
import '../../domain/course.dart';
import '../design.dart';

class ProjectRow extends StatelessWidget {
  const ProjectRow({
    super.key,
    required this.controller,
    required this.project,
  });
  final AppController controller;
  final CourseProject project;

  @override
  Widget build(BuildContext context) {
    final completed =
        controller.profile.exercise(project.exercise.id) ==
        ExerciseState.completed;
    final available = controller.course.projectIsAvailable(project);
    final status = completed
        ? 'Dokončeno'
        : available
        ? '${project.estimatedMinutes} min · klidně na více dní'
        : 'Navazuje na připravované lekce';
    return ListTile(
      key: ValueKey('project-${project.id}'),
      leading: ExcludeSemantics(
        child: Icon(
          completed ? FluentIcons.completed : FluentIcons.fabric_folder,
          size: 20,
          color: Design.accentFor(context),
        ),
      ),
      title: Text('Projekt · ${project.title}'),
      subtitle: Text('${project.subtitle}\nDobrovolný · $status'),
      trailing: const ExcludeSemantics(
        child: Icon(FluentIcons.chevron_right, size: 12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      onPressed: () => controller.openProject(project),
    );
  }
}
