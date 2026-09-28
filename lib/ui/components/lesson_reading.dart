import 'package:fluent_ui/fluent_ui.dart';
import '../../app/app_controller.dart';
import '../../domain/course.dart';
import '../design.dart';
import 'code_block.dart';
import 'lesson_header.dart';
import 'lesson_continuation.dart';
import 'lesson_markdown.dart';
import 'surfaces.dart';

class LessonReading extends StatefulWidget {
  const LessonReading({
    super.key,
    required this.controller,
    required this.lesson,
    this.onExercises,
  });
  final AppController controller;
  final Lesson lesson;
  final VoidCallback? onExercises;
  @override
  State<LessonReading> createState() => _LessonReadingState();
}

class _LessonReadingState extends State<LessonReading> {
  final _scroll = ScrollController(keepScrollOffset: false);
  final _markdown = GlobalKey<LessonMarkdownState>();
  AppController get app => widget.controller;
  Lesson get lesson => widget.lesson;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completed =
        app.profile.lesson(lesson.id).state == LessonState.completed;
    final headings = markdownHeadings(lesson.markdown);
    return PageScroll(
      controller: _scroll,
      maxWidth: Design.readingWidth,
      children: [
        LessonHeader(controller: app, lesson: lesson),
        if (headings.isNotEmpty) ...[
          Expander(
            header: const Text('Obsah lekce'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < headings.length; i++)
                  HyperlinkButton(
                    onPressed: () => _markdown.currentState?.jumpTo(
                      i,
                      animate: !app.reducedMotion,
                    ),
                    child: Text(headings[i]),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        LessonMarkdown(key: _markdown, text: lesson.markdown),
        const SizedBox(height: 16),
        Expander(
          header: const Text('Další ukázky kódu'),
          content: Column(
            children: [
              for (final example in lesson.examples)
                CodeBlock(
                  code: example.code,
                  caption: example.caption,
                  highlightedLines: example.highlightedLines,
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expander(
          header: const Text('Časté chyby'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final mistake in lesson.commonMistakes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: LessonMarkdown(text: mistake),
                ),
            ],
          ),
        ),
        const SectionTitle('Zapamatuj si'),
        LessonMarkdown(text: lesson.takeaway),
        if (lesson.prerequisites.isNotEmpty) ...[
          const SectionTitle('Potřebuješ si něco připomenout?'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final id in lesson.prerequisites)
                HyperlinkButton(
                  onPressed: () => app.openReference(id),
                  child: Text(app.course.lessonsById[id]!.title),
                ),
            ],
          ),
        ],
        const SizedBox(height: 28),
        const Divider(),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (lesson.exercises.isNotEmpty)
              FilledButton(
                onPressed: widget.onExercises,
                child: const Text('Vyzkoušet cvičení'),
              ),
            Button(
              key: const ValueKey('complete-lesson'),
              onPressed: () => app.completeLesson(lesson, !completed),
              child: Text(
                completed
                    ? 'Vrátit mezi rozpracované'
                    : 'Označit lekci jako hotovou',
              ),
            ),
            Button(
              onPressed: () => app.toggleSkipped(lesson.id),
              child: Text(
                app.profile.lesson(lesson.id).skipped
                    ? 'Zrušit odložení'
                    : 'Odložit na později',
              ),
            ),
          ],
        ),
        LessonContinuation(controller: app, lesson: lesson),
      ],
    );
  }
}
