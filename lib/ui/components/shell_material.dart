import 'package:fluent_ui/fluent_ui.dart';
import '../design.dart';

class ShellMaterial extends StatelessWidget {
  const ShellMaterial({
    super.key,
    required this.enabled,
    required this.paneWidth,
    required this.child,
  });
  final bool enabled;
  final double paneWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Design.dark(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: FluentTheme.of(context).micaBackgroundColor,
        gradient: enabled
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dark
                    ? const [
                        Color(0xFF1A2B47),
                        Color(0xFF2C2939),
                        Color(0xFF22303B),
                      ]
                    : const [
                        Color(0xFFDCE7F8),
                        Color(0xFFE9E7F2),
                        Color(0xFFEEF2F8),
                      ],
              )
            : null,
      ),
      child: Stack(
        children: [
          if (enabled && paneWidth > 0)
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              width: paneWidth,
              child: ExcludeSemantics(
                child: IgnorePointer(
                  child: ClipRect(
                    child: Acrylic(
                      tint: dark
                          ? const Color(0xFF23252B)
                          : const Color(0xFFF2F5FA),
                      tintAlpha: 0.86,
                      luminosityAlpha: 0.86,
                      blurAmount: 24,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
            ),
          NavigationPaneTheme.merge(
            data: const NavigationPaneThemeData(
              backgroundColor: Colors.transparent,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
