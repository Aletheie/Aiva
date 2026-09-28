import 'package:fluent_ui/fluent_ui.dart';
import '../../app/app_controller.dart';
import '../../domain/course.dart';
import '../components/lesson_row.dart';
import '../components/project_row.dart';
import '../components/surfaces.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final app = controller;
    final group = app.location.group;
    final search = app.location.page == AppPage.search;
    final favorites = app.location.page == AppPage.favorites;
    final route = app.course.lessons
        .where(
          (l) =>
              group == null ||
              app.course.chaptersById[l.chapter]?.group == group,
        )
        .toList();
    final List<Lesson> lessons = search
        ? app.searchResults
        : favorites
        ? app.course.lessons
              .where((l) => app.profile.lesson(l.id).favorite)
              .toList()
        : route;
    return PageScroll(
      children: [
        PageTitle(
          title: search
              ? 'Výsledky hledání'
              : favorites
              ? 'Oblíbené'
              : 'Celý kurz',
          subtitle: search
              ? '„${app.query}“ · nalezeno: ${lessons.length}'
              : favorites
              ? 'Uložené lekce pro rychlý návrat.'
              : 'Jdi odshora dolů. Projekty potkáš cestou; dobrovolné mezisekce můžeš přeskočit.',
        ),
        if (!search && !favorites) ...[
          Wrap(
            spacing: 20,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              InfoLabel(
                label: 'Oblast kurzu',
                child: ComboBox<String>(
                  value: group ?? '',
                  items: [
                    const ComboBoxItem(
                      value: '',
                      child: Text('Všechna témata'),
                    ),
                    for (final entry in app.course.groups)
                      ComboBoxItem(value: entry, child: Text(entry)),
                  ],
                  onChanged: (value) =>
                      app.openGroup(value == '' ? null : value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Hlavní cesta počítá jen hotové základní lekce. Odbočky a projekty si vybírej podle chuti.',
          ),
        ],
        if ((search || favorites) ? lessons.isEmpty : route.isEmpty)
          EmptyState(
            title: search
                ? 'Žádné výsledky'
                : favorites
                ? 'Zatím žádné oblíbené'
                : 'V této oblasti zatím nejsou lekce',
            message: search
                ? 'Zkus kratší název nebo anglický pojem.'
                : favorites
                ? 'V lekci použij tlačítko s hvězdičkou.'
                : 'Vyber jinou oblast nebo otevři celý kurz.',
            action: Button(
              onPressed: () => app.openGroup(null),
              child: const Text('Otevřít celý kurz'),
            ),
          ),
        if (search || favorites)
          for (final lesson in lessons)
            LessonRow(controller: app, lesson: lesson)
        else
          for (final chapter in app.course.chapters)
            if (route.any((l) => l.chapter == chapter.id)) ...[
              SectionTitle(chapter.title, subtitle: chapter.group),
              for (final lesson in route.where(
                (l) => l.chapter == chapter.id,
              )) ...[
                LessonRow(controller: app, lesson: lesson),
                for (final project in app.course.projectsAfter(lesson.id))
                  ProjectRow(controller: app, project: project),
              ],
            ],
      ],
    );
  }
}
