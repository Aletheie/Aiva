import 'package:fluent_ui/fluent_ui.dart';
import '../design.dart';

class ShortcutKeycap extends StatelessWidget {
  const ShortcutKeycap(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    return ExcludeSemantics(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: theme.resources.controlFillColorDefault,
          border: Border.all(color: theme.resources.controlStrokeColorDefault),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: theme.typography.caption?.copyWith(
            color: Design.muted(context),
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
