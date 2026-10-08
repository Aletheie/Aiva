import 'dart:async';
import 'dart:math' as math;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/java.dart';
import 'package:re_highlight/languages/xml.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/languages/kotlin.dart';
import 'package:re_highlight/languages/markdown.dart';
import '../../services/java_language_service.dart';
import '../design.dart';

/// The editing surface stays native; semantic suggestions come from Eclipse JDT.
class JavaCodeEditor extends StatefulWidget {
  const JavaCodeEditor({
    super.key,
    required this.controller,
    required this.path,
    required this.languageService,
    required this.onSave,
    this.readOnly = false,
  });
  final CodeLineEditingController controller;
  final String path;
  final JavaLanguageService languageService;
  final VoidCallback onSave;
  final bool readOnly;
  @override
  State<JavaCodeEditor> createState() => _JavaCodeEditorState();
}

class _JavaCodeEditorState extends State<JavaCodeEditor> {
  final _focus = FocusNode(debugLabel: 'Editor kódu');
  final _scroll = CodeScrollController();
  final _suggestionScroll = ScrollController();
  Timer? _completionTimer;
  List<JavaCompletion> _suggestions = [];
  int _selected = 0;
  int _request = 0;
  String _lastText = '';
  String? _help;
  CodeLineEditingController get code => widget.controller;
  bool get _java => widget.path.endsWith('.java');

  @override
  void initState() {
    super.initState();
    _lastText = code.text;
    code.addListener(_changed);
  }

  @override
  void didUpdateWidget(JavaCodeEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != code) {
      oldWidget.controller.removeListener(_changed);
      code.addListener(_changed);
      _lastText = code.text;
      _dismiss();
    }
  }

  int get _offset {
    final selection = code.unfoldLineSelection;
    final lines = code.text.split('\n');
    var offset = 0;
    for (var i = 0; i < selection.extentIndex && i < lines.length; i++) {
      offset += lines[i].length + 1;
    }
    return (offset + selection.extentOffset).clamp(0, code.text.length);
  }

  void _changed() {
    final changed = _lastText != code.text;
    _lastText = code.text;
    _dismiss();
    if (changed && _java && !widget.readOnly && _focus.hasFocus) {
      final prefix = code.text.substring(0, _offset);
      if (RegExp(r'[\w.$]$').hasMatch(prefix)) {
        _completionTimer = Timer(const Duration(milliseconds: 260), _complete);
      }
    }
  }

  void _dismiss() {
    _completionTimer?.cancel();
    _request++;
    if (mounted && (_suggestions.isNotEmpty || _help != null)) {
      setState(() {
        _suggestions = [];
        _help = null;
      });
    }
  }

  Future<void> _complete() async {
    if (!_java || widget.readOnly) return;
    final request = ++_request;
    final text = code.text;
    final offset = _offset;
    try {
      final items = await widget.languageService.complete(
        widget.path,
        text,
        offset,
      );
      if (!mounted ||
          request != _request ||
          code.text != text ||
          _offset != offset) {
        return;
      }
      setState(() {
        _suggestions = items.take(60).toList();
        _selected = 0;
        _help = null;
      });
    } on Object {
      // Server availability is reported in the workspace status bar.
    }
  }

  Future<void> _documentation() async {
    final request = ++_request;
    try {
      final text = await widget.languageService.hover(
        widget.path,
        code.text,
        _offset,
      );
      if (!mounted || request != _request) return;
      setState(() {
        _suggestions = [];
        _help = text;
      });
    } on Object {
      /* Availability is shown by the parent. */
    }
  }

  Future<void> _accept([int? index]) async {
    if (_suggestions.isEmpty) return;
    final selected = _suggestions[index ?? _selected];
    final original = code.text;
    final offset = _offset;
    final controller = code;
    _dismiss();
    final request = _request;
    var resolved = selected;
    try {
      resolved = await widget.languageService.resolveCompletion(selected);
    } on Object {
      // Keep the original server edit when optional resolution is unavailable.
    }
    if (!mounted ||
        controller != code ||
        request != _request ||
        code.text != original ||
        _offset != offset) {
      return;
    }
    final result = resolved.apply(original, offset);
    code.runRevocableOp(() {
      code.text = result.text;
      final prefix = result.text.substring(0, result.offset);
      code.selection = CodeLineSelection.collapsed(
        index: '\n'.allMatches(prefix).length,
        offset: prefix.length - prefix.lastIndexOf('\n') - 1,
      );
    });
    _focus.requestFocus();
  }

  @override
  void dispose() {
    _request++;
    _completionTimer?.cancel();
    code.removeListener(_changed);
    _focus.dispose();
    _scroll.verticalScroller.dispose();
    _scroll.horizontalScroller.dispose();
    _scroll.dispose();
    _suggestionScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Design.dark(context);
    final ink = Design.ink(context);
    final accent = Design.accentFor(context);
    final language = widget.path.endsWith('.java')
        ? langJava
        : widget.path.endsWith('.xml')
        ? langXml
        : widget.path.endsWith('.json')
        ? langJson
        : widget.path.endsWith('.kts')
        ? langKotlin
        : widget.path.endsWith('.md')
        ? langMarkdown
        : null;
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space, control: true):
            _complete,
        const SingleActivator(LogicalKeyboardKey.f1): _documentation,
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hasPopup = _suggestions.isNotEmpty || _help != null;
          final width = math
              .min(430.0, constraints.maxWidth - 24)
              .clamp(0.0, 430.0);
          final height = math
              .min(
                _help != null
                    ? 240.0
                    : math.min(240.0, _suggestions.length * 48.0 + 30),
                constraints.maxHeight - 24,
              )
              .clamp(0.0, 240.0);
          final y =
              (code.selection.extentIndex + 1) * 23.4 +
              16 -
              (_scroll.verticalScroller.hasClients
                  ? _scroll.verticalScroller.offset
                  : 0);
          return Stack(
            children: [
              Semantics(
                label:
                    'Zdrojový kód ${widget.path.split(RegExp(r'[/\\]')).last}',
                child: CodeEditor(
                  key: const ValueKey('embedded-code-editor'),
                  controller: code,
                  autofocus: false,
                  focusNode: _focus,
                  scrollController: _scroll,
                  readOnly: widget.readOnly,
                  wordWrap: false,
                  chunkAnalyzer: const NonCodeChunkAnalyzer(),
                  padding: const EdgeInsets.fromLTRB(8, 16, 24, 24),
                  style: CodeEditorStyle(
                    fontFamily: Design.mono,
                    fontSize: 14,
                    fontHeight: 1.65,
                    textColor: ink,
                    backgroundColor: Design.surface(context),
                    cursorColor: accent,
                    cursorLineColor: accent.withValues(alpha: .07),
                    selectionColor: accent.withValues(alpha: .2),
                    codeTheme: language == null
                        ? null
                        : CodeHighlightTheme(
                            languages: {
                              'source': CodeHighlightThemeMode(mode: language),
                            },
                            theme: {
                              'root': TextStyle(color: ink),
                              'keyword': TextStyle(
                                color: dark
                                    ? const Color(0xFF9BBBFF)
                                    : const Color(0xFF245BCB),
                              ),
                              'string': TextStyle(
                                color: dark
                                    ? const Color(0xFFCEAD95)
                                    : const Color(0xFF934521),
                              ),
                              'number': TextStyle(
                                color: dark
                                    ? const Color(0xFFD7A1D9)
                                    : const Color(0xFF86528A),
                              ),
                              'literal': TextStyle(
                                color: dark
                                    ? const Color(0xFFD7A1D9)
                                    : const Color(0xFF86528A),
                              ),
                              'comment': TextStyle(
                                color: dark
                                    ? const Color(0xFFA0B79B)
                                    : const Color(0xFF57714F),
                              ),
                              'title': TextStyle(
                                color: dark
                                    ? const Color(0xFF8BCBC3)
                                    : const Color(0xFF286F68),
                              ),
                              'meta': TextStyle(
                                color: dark
                                    ? const Color(0xFFD7A1D9)
                                    : const Color(0xFF86528A),
                              ),
                            },
                          ),
                  ),
                  indicatorBuilder: (context, editing, chunks, notifier) =>
                      Padding(
                        padding: const EdgeInsets.only(left: 12, right: 16),
                        child: DefaultCodeLineNumber(
                          controller: editing,
                          notifier: notifier,
                        ),
                      ),
                  shortcutOverrideActions: {
                    CodeShortcutSaveIntent:
                        CallbackAction<CodeShortcutSaveIntent>(
                          onInvoke: (_) {
                            widget.onSave();
                            return null;
                          },
                        ),
                    CodeShortcutEscIntent:
                        CallbackAction<CodeShortcutEscIntent>(
                          onInvoke: (_) {
                            final wasOpen =
                                _suggestions.isNotEmpty || _help != null;
                            _dismiss();
                            if (!wasOpen) _focus.nextFocus();
                            return null;
                          },
                        ),
                    if (_suggestions.isNotEmpty) ...{
                      CodeShortcutIndentIntent:
                          CallbackAction<CodeShortcutIndentIntent>(
                            onInvoke: (_) {
                              unawaited(_accept());
                              return null;
                            },
                          ),
                      CodeShortcutNewLineIntent:
                          CallbackAction<CodeShortcutNewLineIntent>(
                            onInvoke: (_) {
                              unawaited(_accept());
                              return null;
                            },
                          ),
                      CodeShortcutCursorMoveIntent:
                          CallbackAction<CodeShortcutCursorMoveIntent>(
                            onInvoke: (intent) {
                              if (intent.direction == AxisDirection.up ||
                                  intent.direction == AxisDirection.down) {
                                setState(
                                  () => _selected =
                                      (_selected +
                                              (intent.direction ==
                                                      AxisDirection.up
                                                  ? -1
                                                  : 1))
                                          .clamp(0, _suggestions.length - 1),
                                );
                                if (_suggestionScroll.hasClients) {
                                  _suggestionScroll.jumpTo(
                                    (_selected * 48.0).clamp(
                                      0.0,
                                      _suggestionScroll
                                          .position
                                          .maxScrollExtent,
                                    ),
                                  );
                                }
                              } else {
                                _dismiss();
                                code.moveCursor(intent.direction);
                              }
                              return null;
                            },
                          ),
                    },
                  },
                  findBuilder: (context, find, readOnly) => PreferredSize(
                    preferredSize: Size.fromHeight(find.value == null ? 0 : 52),
                    child: find.value == null
                        ? const SizedBox.shrink()
                        : Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 52,
                              color: Design.surface(context),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextBox(
                                      controller: find.findInputController,
                                      focusNode: find.findInputFocusNode,
                                      placeholder: 'Hledat v souboru',
                                      onSubmitted: (_) => find.nextMatch(),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(FluentIcons.chevron_up),
                                    onPressed: find.previousMatch,
                                  ),
                                  IconButton(
                                    icon: const Icon(FluentIcons.chevron_down),
                                    onPressed: find.nextMatch,
                                  ),
                                  IconButton(
                                    icon: const Icon(FluentIcons.chrome_close),
                                    onPressed: find.close,
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              if (hasPopup && height > 48)
                Positioned(
                  left: math.min(
                    60,
                    math.max(12, constraints.maxWidth - width - 12),
                  ),
                  top: y.clamp(
                    12.0,
                    math.max(12.0, constraints.maxHeight - height - 12),
                  ),
                  width: width,
                  height: height,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Design.surface(context),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: accent),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _help != null
                        ? SingleChildScrollView(
                            padding: const EdgeInsets.all(12),
                            child: SelectableText(
                              _help!,
                              style: TextStyle(
                                fontFamily: Design.mono,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  controller: _suggestionScroll,
                                  itemCount: _suggestions.length,
                                  itemExtent: 48,
                                  itemBuilder: (context, index) {
                                    final item = _suggestions[index];
                                    return Semantics(
                                      selected: index == _selected,
                                      child: HoverButton(
                                        onPressed: () => _accept(index),
                                        builder: (context, states) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 5,
                                          ),
                                          color:
                                              index == _selected ||
                                                  states.isHovered
                                              ? accent.withValues(alpha: .13)
                                              : null,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.label,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: Design.mono,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                item.detail,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Design.muted(context),
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(6),
                                child: Text(
                                  '↑ ↓ vybrat   ·   Tab doplnit   ·   Esc zavřít',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
