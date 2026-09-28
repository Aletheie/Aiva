import 'package:fluent_ui/fluent_ui.dart';
import '../../app/app_controller.dart';
import '../design.dart';
import '../components/lesson_row.dart';
import '../components/surfaces.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});
  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final app = controller;
    final lesson = app.resumeLesson;
    final completed = app.profile.completedCount(app.course);
    final total = app.course.mainPath.length;
    final started = app.profile.recent.isNotEmpty;
    final groups = app.course.groups.where(
      (group) => app.course.inGroup(group).any((l) => l.isPublished),
    );
    return PageScroll(
      children: [
        const PageTitle(
          title: 'Přehled',
          subtitle: 'První kroky v Javě. Vlastním tempem, od úplného začátku.',
        ),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                started ? 'Poslední otevřená lekce' : 'Začni tady',
                style: FluentTheme.of(context).typography.bodyStrong?.copyWith(
                  color: Design.accentFor(context),
                ),
              ),
              const SizedBox(height: 12),
              Semantics(
                header: true,
                child: Text(
                  lesson.title,
                  style: FluentTheme.of(context).typography.title,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lesson.subtitle,
                style: TextStyle(color: Design.muted(context), height: 1.5),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilledButton(
                    key: const ValueKey('continue-course'),
                    onPressed: () => app.openLesson(lesson),
                    child: Text(
                      started ? 'Pokračovat v lekci' : 'Otevřít první lekci',
                    ),
                  ),
                  Text(
                    'Přibližně ${lesson.estimatedMinutes} minut',
                    style: TextStyle(color: Design.muted(context)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Text('$completed z $total lekcí hlavní cesty dokončeno'),
            ),
            HyperlinkButton(
              onPressed: () => app.go(const PageLocation(AppPage.progress)),
              child: const Text('Můj postup'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ProgressBar(
          value: app.profile.fraction(app.course) * 100,
          semanticLabel: 'Dokončeno $completed z $total lekcí',
        ),
        const SizedBox(height: 8),
        Text(
          'Stačí jedna krátká lekce a jedno cvičení. Dobrovolné mezisekce a projekty najdeš přímo v kurzu.',
          style: TextStyle(color: Design.muted(context), height: 1.5),
        ),
        if (app.profile.recent.where((id) => id != lesson.id).isNotEmpty) ...[
          const SectionTitle('Nedávno otevřené'),
          for (final id
              in app.profile.recent.where((id) => id != lesson.id).take(3))
            if (app.course.lessonsById[id] case final recent?)
              LessonRow(controller: app, lesson: recent),
        ],
        SectionTitle(
          'Vybrat téma',
          trailing: HyperlinkButton(
            onPressed: () => app.openGroup(null),
            child: const Text('Celý kurz'),
          ),
        ),
        for (final group in groups)
          ListTile(
            leading: const ExcludeSemantics(
              child: Icon(FluentIcons.reading_mode, size: 20),
            ),
            title: Text(group),
            subtitle: Text(
              '${app.course.inGroup(group).where((l) => l.isPublished).length} lekcí',
            ),
            trailing: const ExcludeSemantics(
              child: Icon(FluentIcons.chevron_right, size: 12),
            ),
            onPressed: () => app.openGroup(group),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        const SectionTitle('Chceš si něco zopakovat?'),
        Text(
          'V hledání najdeš české i anglické názvy pojmů. Ve výkladu tě odkazy vrátí k souvisejícím lekcím.',
          style: TextStyle(color: Design.muted(context), height: 1.5),
        ),
      ],
    );
  }
}
