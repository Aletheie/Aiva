import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../ui/app_shell.dart';
import '../ui/design.dart';
import '../ui/components/lesson_links.dart';
import 'app_controller.dart';

class AivaApp extends StatelessWidget {
  const AivaApp({super.key, required this.controller});
  final AppController controller;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) {
      final mode = switch (controller.profile.setting('theme', 'system')) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      };
      final systemReduce = WidgetsBinding
          .instance
          .platformDispatcher
          .accessibilityFeatures
          .disableAnimations;
      return FluentApp(
        title: 'Aiva',
        debugShowCheckedModeBanner: false,
        theme: Design.theme(
          Brightness.light,
          reducedMotion: controller.reducedMotion || systemReduce,
        ),
        darkTheme: Design.theme(
          Brightness.dark,
          reducedMotion: controller.reducedMotion || systemReduce,
        ),
        themeMode: mode,
        locale: const Locale('cs'),
        localizationsDelegates: const [
          FluentLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('cs'), Locale('en')],
        builder: (context, child) {
          final media = MediaQuery.of(context);
          return MediaQuery(
            data: media.copyWith(
              textScaler: _ScaledText(media.textScaler, controller.textScale),
              disableAnimations:
                  media.disableAnimations || controller.reducedMotion,
            ),
            child: LessonLinks(
              controller: controller,
              child: child ?? const SizedBox.shrink(),
            ),
          );
        },
        home: AppShell(controller: controller),
      );
    },
  );
}

/// Preserve the platform's possibly nonlinear accessibility scale.
final class _ScaledText extends TextScaler {
  const _ScaledText(this.base, this.factor);
  final TextScaler base;
  final double factor;
  @override
  double scale(double fontSize) => base.scale(fontSize) * factor;
  @override
  double get textScaleFactor => base.scale(14) / 14 * factor;
  @override
  bool operator ==(Object other) =>
      other is _ScaledText && other.base == base && other.factor == factor;
  @override
  int get hashCode => Object.hash(base, factor);
}
