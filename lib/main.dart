import 'dart:async';
import 'dart:io';
import 'dart:ui' show AppExitResponse;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/app_controller.dart';
import 'app/aiva_app.dart';
import 'content/bundle_content_source.dart';
import 'content/course_loader.dart';
import 'persistence/sqlite_repository.dart';
import 'platform/app_paths.dart';
import 'ui/design.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AivaBootstrap());
}

Future<AppController> loadApplication({String? profileOverride}) async {
  final source = await BundleContentSource.load();
  final course = await CourseLoader(source).load();
  final paths = await AppPaths.load(
    profileOverride: profileOverride ?? Platform.environment['AIVA_PROFILE'],
  );
  final store = SqliteProfileStore(paths.database);
  final profile = await store.load();
  return AppController(
    course: course,
    source: source,
    store: store,
    paths: paths,
    profile: profile,
  );
}

class AivaBootstrap extends StatefulWidget {
  const AivaBootstrap({super.key});
  @override
  State<AivaBootstrap> createState() => _AivaBootstrapState();
}

class _AivaBootstrapState extends State<AivaBootstrap> {
  AppController? _app;
  Object? _error;
  bool _loading = false;
  late final AppLifecycleListener _lifecycle;
  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onExitRequested: () async {
        _app?.cancelCheck();
        final deadline = DateTime.now().add(const Duration(seconds: 7));
        while ((_app?.isRunning ?? false) &&
            DateTime.now().isBefore(deadline)) {
          await Future<void>.delayed(const Duration(milliseconds: 40));
        }
        return AppExitResponse.exit;
      },
    );
    unawaited(_load());
  }

  Future<void> _load() async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final app = await loadApplication();
      if (!mounted) {
        app.dispose();
        return;
      }
      setState(() => _app = app);
      unawaited(app.detectTools());
    } on Object catch (error, stack) {
      debugPrint('$error\n$stack');
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _app?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = _app;
    if (app != null) return AivaApp(controller: app);
    return FluentApp(
      title: 'Aiva',
      debugShowCheckedModeBanner: false,
      theme: Design.theme(Brightness.light),
      darkTheme: Design.theme(Brightness.dark),
      locale: const Locale('cs'),
      supportedLocales: const [Locale('cs'), Locale('en')],
      localizationsDelegates: const [
        FluentLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: NavigationView(
        content: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Aiva',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),
                  if (_error == null) ...[
                    const ProgressRing(),
                    const SizedBox(height: 18),
                    const Text('Otevírám kurz…'),
                  ] else ...[
                    const Text(
                      'Kurz se nepodařilo otevřít.',
                      style: TextStyle(fontSize: 19),
                    ),
                    const SizedBox(height: 14),
                    SelectableText('$_error'),
                    const SizedBox(height: 18),
                    const Text(
                      'Profil se automaticky nemaže ani nenahrazuje. '
                      'Zkontroluj oprávnění a úplnost instalace.',
                    ),
                    const SizedBox(height: 20),
                    Button(
                      onPressed: _loading ? null : _load,
                      child: const Text('Zkusit znovu'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
