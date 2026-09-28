import 'dart:async';
import 'dart:math' as math;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import '../../content/java_tokens.dart';
import '../design.dart';

class CodeBlock extends StatefulWidget {
  const CodeBlock({
    super.key,
    required this.code,
    this.caption = 'Java',
    this.highlightedLines = const [],
    this.language = 'java',
  });
  final String code;
  final String caption;
  final List<int> highlightedLines;
  final String language;
  @override
  State<CodeBlock> createState() => _CodeBlockState();
}

class _CodeBlockState extends State<CodeBlock> {
  final ScrollController _horizontal = ScrollController();
  Timer? _copyTimer;
  String _copyLabel = 'Kopírovat';
  late List<List<JavaToken>> _lines;
  @override
  void initState() {
    super.initState();
    _tokenize();
  }

  void _tokenize() => _lines = javaTokenLines(
    widget.code,
    highlight: widget.language == 'java',
  );
  @override
  void didUpdateWidget(CodeBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.code != oldWidget.code ||
        widget.language != oldWidget.language) {
      _tokenize();
    }
  }

  @override
  void dispose() {
    _copyTimer?.cancel();
    _horizontal.dispose();
    super.dispose();
  }

  Future<void> _copy() async {
    try {
      await Clipboard.setData(ClipboardData(text: widget.code));
      if (!mounted) return;
      setState(() => _copyLabel = 'Zkopírováno');
      _copyTimer?.cancel();
      _copyTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _copyLabel = 'Kopírovat');
      });
    } on Object {
      if (mounted) setState(() => _copyLabel = 'Kopírování selhalo');
    }
  }

  Color _color(BuildContext context, JavaTokenKind kind) {
    final dark = Design.dark(context);
    return switch (kind) {
      JavaTokenKind.keyword =>
        dark ? const Color(0xFFCEBFFF) : const Color(0xFF69418D),
      JavaTokenKind.string =>
        dark ? const Color(0xFFA6DAB4) : const Color(0xFF306B45),
      JavaTokenKind.comment =>
        dark ? const Color(0xFFA4B9B6) : const Color(0xFF5C746D),
      JavaTokenKind.number =>
        dark ? const Color(0xFFF0C2A0) : const Color(0xFF965027),
      JavaTokenKind.annotation =>
        dark ? const Color(0xFFE9D494) : const Color(0xFF795817),
      JavaTokenKind.plain => Design.ink(context),
    };
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontFamily: Design.mono,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.65,
      color: Design.ink(context),
    );
    final scale = MediaQuery.textScalerOf(context);
    var textWidth = 0.0;
    for (final line in widget.code.split('\n')) {
      final painter = TextPainter(
        text: TextSpan(text: line.isEmpty ? ' ' : line, style: style),
        textDirection: TextDirection.ltr,
        textScaler: scale,
      )..layout();
      textWidth = math.max(textWidth, painter.width);
      painter.dispose();
    }
    final numbered = widget.language == 'java';
    final gutter = numbered
        ? 24.0 + _lines.length.toString().length * 9 * scale.scale(1)
        : 16.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Card(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 10, 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Design.border(context)),
                ),
              ),
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      numbered ? FluentIcons.code : FluentIcons.align_left,
                      size: 14,
                      color: Design.accentFor(context),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      widget.caption,
                      style: TextStyle(
                        fontSize: 12,
                        color: Design.muted(context),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: 'Zkopírovat obsah',
                    child: Button(
                      onPressed: _copy,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const ExcludeSemantics(
                            child: Icon(FluentIcons.copy, size: 12),
                          ),
                          const SizedBox(width: 6),
                          Semantics(liveRegion: true, child: Text(_copyLabel)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = math.max(
                  constraints.maxWidth,
                  textWidth + gutter + 40,
                );
                return Scrollbar(
                  controller: _horizontal,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _horizontal,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: SizedBox(
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < _lines.length; i++)
                            Container(
                              color: widget.highlightedLines.contains(i + 1)
                                  ? Design.accentFor(
                                      context,
                                    ).withValues(alpha: 0.11)
                                  : null,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ExcludeSemantics(
                                    child: SizedBox(
                                      width: gutter,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        child: numbered
                                            ? Text(
                                                '${i + 1}',
                                                textAlign: TextAlign.right,
                                                style: style.copyWith(
                                                  color: Design.muted(context),
                                                ),
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SelectableText.rich(
                                      TextSpan(
                                        style: style,
                                        children: [
                                          if (_lines[i].every(
                                            (t) => t.text.isEmpty,
                                          ))
                                            const TextSpan(text: ' '),
                                          for (final token in _lines[i])
                                            TextSpan(
                                              text: token.text,
                                              style: TextStyle(
                                                color: _color(
                                                  context,
                                                  token.kind,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
