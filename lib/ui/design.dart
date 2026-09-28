import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';

abstract final class Design {
  static const accent = Color(0xFF245BCB);
  static const darkAccent = Color(0xFF9BBBFF);
  static const radius = 8.0;
  static const gap = 16.0;
  static const pageWidth = 1080.0;
  static const readingWidth = 800.0;
  static String get mono => Platform.isMacOS
      ? 'Menlo'
      : Platform.isWindows
      ? 'Consolas'
      : 'monospace';
  static bool dark(BuildContext context) =>
      FluentTheme.of(context).brightness == Brightness.dark;
  static Color ink(BuildContext context) =>
      FluentTheme.of(context).resources.textFillColorPrimary;
  static Color muted(BuildContext context) =>
      FluentTheme.of(context).resources.textFillColorSecondary;
  static Color surface(BuildContext context) =>
      FluentTheme.of(context).cardColor;
  static Color border(BuildContext context) =>
      FluentTheme.of(context).resources.cardStrokeColorDefault;
  static Color accentFor(BuildContext context) =>
      dark(context) ? darkAccent : accent;

  static FluentThemeData theme(
    Brightness brightness, {
    bool reducedMotion = false,
  }) {
    final isDark = brightness == Brightness.dark;
    return FluentThemeData(
      brightness: brightness,
      accentColor: AccentColor.swatch({
        'darkest': const Color(0xFF173C86),
        'darker': const Color(0xFF1C49A4),
        'dark': const Color(0xFF2052B8),
        'normal': accent,
        'light': const Color(0xFF779FEF),
        'lighter': darkAccent,
        'lightest': const Color(0xFFD8E5FF),
      }),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF202020)
          : const Color(0xFFF5F5F5),
      acrylicBackgroundColor: isDark
          ? const Color(0xFF242424)
          : const Color(0xFFF1F1F1),
      cardColor: isDark ? const Color(0xFF2B2B2B) : Colors.white,
      selectionColor: (isDark ? darkAccent : accent).withValues(alpha: 0.25),
      fasterAnimationDuration: reducedMotion
          ? Duration.zero
          : const Duration(milliseconds: 80),
      fastAnimationDuration: reducedMotion
          ? Duration.zero
          : const Duration(milliseconds: 120),
      mediumAnimationDuration: reducedMotion
          ? Duration.zero
          : const Duration(milliseconds: 180),
      slowAnimationDuration: reducedMotion
          ? Duration.zero
          : const Duration(milliseconds: 220),
    );
  }
}
