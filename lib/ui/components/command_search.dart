import 'dart:math' as math;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import '../../app/app_controller.dart';
import '../../domain/course.dart';
import '../design.dart';
import 'shortcut_keycap.dart';

Future<void> showCommandSearch(
  BuildContext context,
  AppController app, {
  FocusNode? returnFocus,
}) async {
  final previousFocus = returnFocus ?? FocusManager.instance.primaryFocus;
  previousFocus?.requestFocus();
  await showDialog<void>(
    context: context,
    builder: (context) => _CommandSearch(controller: app),
  );
  if (previousFocus?.context?.mounted == true) previousFocus!.requestFocus();
}

class _SearchAction {
  const _SearchAction(this.title, this.description, this.icon, this.open);
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback open;
}

class _CommandSearch extends StatefulWidget {
  const _CommandSearch({required this.controller});
  final AppController controller;
  @override
  State<_CommandSearch> createState() => _CommandSearchState();
}

class _CommandSearchState extends State<_CommandSearch> {
  final _text = TextEditingController();
  final _focus = FocusNode(debugLabel: 'Hledat lekci nebo akci');
  final _scroll = ScrollController();
  final _resultKeys = <GlobalKey>[];
  int _selected = 0;
  bool _opening = false;
  AppController get app => widget.controller;

  @override
  void initState() {
    super.initState();
    _focus.onKeyEvent = (node, event) {
      if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
        return KeyEventResult.ignored;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _move(1);
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _move(-1);
        return KeyEventResult.handled;
      }
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.numpadEnter) {
        _open();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
  }

  List<_SearchAction> get _results {
    final query = _text.text.trim();
    final lessons = query.isEmpty
        ? [
            for (final id in {app.resumeLesson.id, ...app.profile.recent})
              ?app.course.lessonsById[id],
          ].take(4)
        : app.courseSearch.find(query).take(12);
    final actions = [
      for (final lesson in lessons)
        _SearchAction(
          lesson.title,
          lesson.isPublished ? lesson.subtitle : 'Téma se připravuje',
          FluentIcons.reading_mode,
          () => app.openLesson(lesson),
        ),
    ];
    for (final action in [
      _SearchAction(
        'Celý kurz',
        'Procházet témata a lekce',
        FluentIcons.library,
        () => app.openGroup(null),
      ),
      _SearchAction(
        'Projekty',
        'Samostatné úlohy',
        FluentIcons.fabric_folder,
        () => app.go(const PageLocation(AppPage.projects)),
      ),
      _SearchAction(
        'Nastavení',
        'Vzhled, Java a editor',
        FluentIcons.settings,
        () => app.go(const PageLocation(AppPage.settings)),
      ),
      _SearchAction(
        'Můj postup',
        'Dokončené lekce a cvičení',
        FluentIcons.chart,
        () => app.go(const PageLocation(AppPage.progress)),
      ),
    ]) {
      if (query.isEmpty ||
          searchable(
            '${action.title} ${action.description}',
          ).contains(searchable(query))) {
        actions.add(action);
      }
    }
    return actions;
  }

  void _move(int delta) {
    final count = _results.length;
    if (count == 0) return;
    setState(() => _selected = (_selected + delta) % count);
    final target = _resultKeys[_selected].currentContext;
    if (target != null) Scrollable.ensureVisible(target, alignment: 0.5);
  }

  void _open([int? index]) {
    if (_opening) return;
    final results = _results;
    if (results.isEmpty) return;
    _opening = true;
    final action = results[index ?? _selected.clamp(0, results.length - 1)];
    Navigator.of(context).pop();
    action.open();
  }

  @override
  void dispose() {
    _text.dispose();
    _focus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    while (_resultKeys.length < results.length) {
      _resultKeys.add(GlobalKey());
    }
    final media = MediaQuery.of(context);
    final theme = FluentTheme.of(context);
    final glass = app.acrylic && !media.highContrast;
    final dialog = CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowDown): () => _move(1),
        const SingleActivator(LogicalKeyboardKey.arrowUp): () => _move(-1),
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).pop(),
      },
      child: ContentDialog(
        style: ContentDialogThemeData(
          padding: EdgeInsets.zero,
          bodyPadding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: Design.surface(context).withValues(alpha: glass ? 0.84 : 1),
            border: Border.all(color: Design.border(context)),
            borderRadius: BorderRadius.circular(Design.radius),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: 680,
          maxHeight: math.max(280, media.size.height - 64),
        ),
        content: Semantics(
          namesRoute: true,
          scopesRoute: true,
          explicitChildNodes: true,
          label: 'Hledat v AIVA',
          child: SizedBox(
            height: math.max(280, math.min(560, media.size.height - 64)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Design.border(context)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          label: 'Hledat lekci, pojem nebo akci',
                          textField: true,
                          child: TextBox(
                            key: const ValueKey('command-search-input'),
                            controller: _text,
                            focusNode: _focus,
                            autofocus: true,
                            placeholder: 'Hledat lekci, pojem nebo akci…',
                            style: theme.typography.body?.copyWith(
                              fontSize: 16,
                            ),
                            placeholderStyle: theme.typography.body?.copyWith(
                              fontSize: 16,
                              color: Design.muted(context),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 18,
                            ),
                            decoration: const WidgetStatePropertyAll(
                              BoxDecoration(
                                color: Colors.transparent,
                                border: Border.fromBorderSide(BorderSide.none),
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            foregroundDecoration: const WidgetStatePropertyAll(
                              BoxDecoration(
                                border: Border.fromBorderSide(BorderSide.none),
                              ),
                            ),
                            prefix: Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: ExcludeSemantics(
                                child: Icon(
                                  FluentIcons.search,
                                  size: 20,
                                  color: Design.muted(context),
                                ),
                              ),
                            ),
                            onChanged: (_) => setState(() => _selected = 0),
                            onSubmitted: (_) => _open(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Tooltip(
                          message: 'Zavřít (Esc)',
                          child: Semantics(
                            label: 'Zavřít hledání',
                            child: Button(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ButtonStyle(
                                padding: const WidgetStatePropertyAll(
                                  EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                ),
                                textStyle: WidgetStatePropertyAll(
                                  theme.typography.caption?.copyWith(
                                    color: Design.muted(context),
                                  ),
                                ),
                              ),
                              child: const ExcludeSemantics(child: Text('Esc')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      _text.text.trim().isEmpty
                          ? 'Pokračovat nebo přejít na'
                          : 'Nalezeno: ${results.length}',
                      style: theme.typography.caption?.copyWith(
                        color: Design.muted(context),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: results.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              'Žádné výsledky. Zkus kratší název nebo anglický pojem.',
                              textAlign: TextAlign.center,
                              style: theme.typography.body?.copyWith(
                                color: Design.muted(context),
                              ),
                            ),
                          ),
                        )
                      : Scrollbar(
                          controller: _scroll,
                          child: ListView.builder(
                            controller: _scroll,
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final result = results[index];
                              final selected = index == _selected;
                              return Semantics(
                                key: _resultKeys[index],
                                selected: selected,
                                child: ListTile(
                                  margin: const EdgeInsets.only(bottom: 2),
                                  contentPadding: const EdgeInsets.fromLTRB(
                                    0,
                                    10,
                                    12,
                                    10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: selected && media.highContrast
                                        ? BorderSide(
                                            color: Design.accentFor(context),
                                          )
                                        : BorderSide.none,
                                  ),
                                  tileColor: WidgetStateColor.resolveWith(
                                    (states) => selected
                                        ? Design.accentFor(context).withValues(
                                            alpha: states.isHovered
                                                ? 0.18
                                                : 0.1,
                                          )
                                        : ButtonThemeData.uncheckedInputColor(
                                            theme,
                                            states,
                                            transparentWhenNone: true,
                                          ),
                                  ),
                                  leading: ExcludeSemantics(
                                    child: Icon(
                                      result.icon,
                                      size: 18,
                                      color: selected
                                          ? Design.accentFor(context)
                                          : Design.muted(context),
                                    ),
                                  ),
                                  title: Text(
                                    result.title,
                                    maxLines: 3,
                                    softWrap: true,
                                    style: theme.typography.body?.copyWith(
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  subtitle: Text(
                                    result.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.typography.caption?.copyWith(
                                      color: Design.muted(context),
                                    ),
                                  ),
                                  trailing: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Visibility(
                                      visible: selected,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: const ShortcutKeycap('↵'),
                                    ),
                                  ),
                                  onPressed: () => _open(index),
                                ),
                              );
                            },
                          ),
                        ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Design.border(context)),
                    ),
                  ),
                  child: Semantics(
                    label: 'Šipky nahoru a dolů pro výběr, Enter pro otevření.',
                    excludeSemantics: true,
                    child: DefaultTextStyle.merge(
                      style: theme.typography.caption?.copyWith(
                        color: Design.muted(context),
                      ),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 8,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              ShortcutKeycap('↑'),
                              SizedBox(width: 4),
                              ShortcutKeycap('↓'),
                              SizedBox(width: 8),
                              Text('výběr'),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              ShortcutKeycap('Enter'),
                              SizedBox(width: 8),
                              Text('otevřít'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (!glass) return dialog;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: math.min(680, media.size.width - 40),
        ),
        child: IntrinsicHeight(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Acrylic(
              tint: FluentTheme.of(context).acrylicBackgroundColor,
              luminosityAlpha: 0.92,
              tintAlpha: 0.92,
              blurAmount: 16,
              child: dialog,
            ),
          ),
        ),
      ),
    );
  }
}
