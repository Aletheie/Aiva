import 'package:fluent_ui/fluent_ui.dart';
import '../../domain/course.dart';
import '../design.dart';
import 'lesson_markdown.dart';

class ExerciseStoryPanel extends StatefulWidget {
  const ExerciseStoryPanel({super.key, required this.story});

  final ExerciseStory story;

  @override
  State<ExerciseStoryPanel> createState() => _ExerciseStoryPanelState();
}

class _ExerciseStoryPanelState extends State<ExerciseStoryPanel> {
  bool _expanded = false;
  bool _opened = false;

  @override
  Widget build(BuildContext context) => Expander(
    initiallyExpanded: false,
    animationDuration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 180),
    onStateChanged: (expanded) => setState(() {
      _expanded = expanded;
      _opened |= expanded;
    }),
    header: Semantics(
      expanded: _expanded,
      child: const Text('Příběh v pozadí'),
    ),
    content: _opened
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.story.world,
                style: FluentTheme.of(
                  context,
                ).typography.caption?.copyWith(color: Design.muted(context)),
              ),
              const SizedBox(height: 12),
              LessonMarkdown(text: widget.story.text),
            ],
          )
        : const SizedBox.shrink(),
  );
}
