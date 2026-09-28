import 'dart:async';
import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import '../app/app_controller.dart';
import '../platform/window_chrome.dart';
import 'components/command_search.dart';
import 'components/pane_selection.dart';
import 'components/shell_material.dart';
import 'components/shortcut_keycap.dart';
import 'design.dart';
import 'pages/home_page.dart';
import 'pages/library_page.dart';
import 'pages/lesson_page.dart';
import 'pages/projects_page.dart';
import 'pages/progress_page.dart';
import 'pages/settings_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.controller});
  final AppController controller;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _searchOpen = false;
  final _searchFocus = FocusNode(debugLabel: 'Hledat v kurzu');
  late final _navigationFocus = {
    for (final page in _pages)
      page: FocusNode(debugLabel: 'Navigace: ${page.name}'),
  };
  AppController get app => widget.controller;
  static const _pages = [
    AppPage.home,
    AppPage.library,
    AppPage.favorites,
    AppPage.projects,
    AppPage.progress,
    AppPage.settings,
  ];

  int get _selected => switch (app.location.page) {
    AppPage.lesson || AppPage.search => 1,
    AppPage.project => 3,
    final page => _pages.indexOf(page),
  };

  Future<void> _search({FocusNode? returnFocus}) async {
    if (_searchOpen) return;
    _searchOpen = true;
    try {
      await showCommandSearch(
        context,
        app,
        returnFocus:
            returnFocus ??
            (FocusManager.instance.primaryFocus is FocusScopeNode
                ? _searchFocus
                : null),
      );
    } finally {
      _searchOpen = false;
    }
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    for (final focus in _navigationFocus.values) {
      focus.dispose();
    }
    super.dispose();
  }

  PaneItem _item(AppPage page, String title, IconData icon, String key) =>
      InsetPaneItem(
        key: ValueKey(key),
        focusNode: _navigationFocus[page],
        onTap: () {
          _navigationFocus[page]!.requestFocus();
          // Fluent only calls onChanged for a different pane index. A selected
          // section still needs to open its overview from a detail or filter.
          if (app.location.page != page || app.location.group != null) {
            app.go(PageLocation(page));
          }
        },
        icon: ExcludeSemantics(child: Icon(icon)),
        title: Text(title),
        body: const SizedBox.shrink(),
      );

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final compact =
        !Platform.isMacOS &&
        (media.size.width < 1060 || media.textScaler.scale(14) > 19);
    const paneWidth = 240.0;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true): _search,
        const SingleActivator(LogicalKeyboardKey.keyK, control: true): _search,
        const SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true):
            app.back,
      },
      child: ShellMaterial(
        enabled: app.acrylic && !media.highContrast,
        paneWidth: media.size.width < 660
            ? 0
            : compact
            ? 50
            : paneWidth,
        child: PaneSelection(
          selected: _selected,
          builder: (indicator) => NavigationView(
            pane: NavigationPane(
              selected: _selected,
              indicator: indicator,
              onChanged: (index) => app.go(PageLocation(_pages[index])),
              displayMode: media.size.width < 660
                  ? PaneDisplayMode.minimal
                  : compact
                  ? PaneDisplayMode.compact
                  : PaneDisplayMode.expanded,
              size: const NavigationPaneSize(
                openWidth: paneWidth,
                headerHeight: 56,
              ),
              toggleButton: Platform.isMacOS ? null : const PaneToggleButton(),
              header: Row(
                children: [
                  Expanded(
                    child: ExcludeSemantics(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onPanStart: (_) =>
                            unawaited(WindowChrome.startDragging()),
                        onDoubleTap: () =>
                            unawaited(WindowChrome.doubleClick()),
                        child: const SizedBox(height: 56),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Zpět (Alt + ←)',
                    child: IconButton(
                      key: const ValueKey('navigation-back'),
                      icon: const Icon(FluentIcons.back, size: 16),
                      onPressed: app.canGoBack ? app.back : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
              acrylicDisabled: !app.acrylic || media.highContrast,
              toggleButtonPosition: PaneToggleButtonPreferredPosition.pane,
              items: [
                if (!compact)
                  PaneItemWidgetAdapter(
                    applyPadding: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 20, 20),
                      child: Row(
                        children: [
                          ExcludeSemantics(
                            child: Icon(
                              FluentIcons.code,
                              size: 24,
                              color: Design.accentFor(context),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'AIVA',
                              style: FluentTheme.of(
                                context,
                              ).typography.subtitle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                InsetPaneItemAction(
                  key: const ValueKey('course-search'),
                  focusNode: _searchFocus,
                  icon: const Icon(FluentIcons.search),
                  title: const Text('Hledat'),
                  tileColor: WidgetStateProperty.resolveWith((states) {
                    final resources = FluentTheme.of(context).resources;
                    return states.isHovered || states.isPressed
                        ? resources.controlFillColorSecondary
                        : resources.controlFillColorDefault;
                  }),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ShortcutKeycap(Platform.isMacOS ? '⌘ K' : 'Ctrl K'),
                  ),
                  onTap: () => _search(returnFocus: _searchFocus),
                ),
                PaneItemSeparator(),
                _item(AppPage.home, 'Přehled', FluentIcons.home, 'nav-home'),
                _item(
                  AppPage.library,
                  'Celý kurz',
                  FluentIcons.reading_mode,
                  'nav-library',
                ),
                _item(
                  AppPage.favorites,
                  'Oblíbené',
                  FluentIcons.favorite_star,
                  'nav-favorites',
                ),
                PaneItemSeparator(),
                _item(
                  AppPage.projects,
                  'Projekty',
                  FluentIcons.fabric_folder,
                  'nav-projects',
                ),
                _item(
                  AppPage.progress,
                  'Můj postup',
                  FluentIcons.chart,
                  'nav-progress',
                ),
              ],
              footerItems: [
                _item(
                  AppPage.settings,
                  'Nastavení',
                  FluentIcons.settings,
                  'nav-settings',
                ),
              ],
            ),
            paneBodyBuilder: (item, body) => ColoredBox(
              color: FluentTheme.of(context).scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (app.notice case final notice?)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                      child: Semantics(
                        liveRegion: true,
                        child: InfoBar(
                          title: Text(notice.message),
                          isLong: true,
                          severity: switch (notice.kind) {
                            NoticeKind.error => InfoBarSeverity.error,
                            NoticeKind.success => InfoBarSeverity.success,
                            NoticeKind.info => InfoBarSeverity.info,
                          },
                          onClose: app.dismissNotice,
                        ),
                      ),
                    ),
                  if (app.isRunning)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: ProgressRing(strokeWidth: 2),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Semantics(
                              liveRegion: true,
                              child: Text(app.runStage),
                            ),
                          ),
                          Button(
                            onPressed: app.cancelCheck,
                            child: const Text('Zrušit'),
                          ),
                        ],
                      ),
                    ),
                  Expanded(child: FocusTraversalGroup(child: _page())),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _page() => switch (app.location.page) {
    AppPage.home => HomePage(controller: app),
    AppPage.library || AppPage.search || AppPage.favorites => LibraryPage(
      key: ValueKey('${app.location.page}-${app.location.group}'),
      controller: app,
    ),
    AppPage.lesson =>
      app.currentLesson == null
          ? const SizedBox.shrink()
          : LessonPage(
              key: ValueKey(app.location),
              controller: app,
              lesson: app.currentLesson!,
            ),
    AppPage.projects => ProjectsPage(controller: app),
    AppPage.project =>
      app.currentProject == null
          ? const SizedBox.shrink()
          : ProjectPage(
              key: ValueKey(app.currentProject!.id),
              controller: app,
              project: app.currentProject!,
            ),
    AppPage.progress => ProgressPage(controller: app),
    AppPage.settings => SettingsPage(controller: app),
  };
}
