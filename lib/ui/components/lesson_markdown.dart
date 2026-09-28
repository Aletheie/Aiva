import 'package:fluent_ui/fluent_ui.dart';
import 'package:markdown/markdown.dart' as md;
import '../design.dart';
import 'code_block.dart';
import 'lesson_links.dart';

class LessonMarkdown extends StatefulWidget {
  const LessonMarkdown({super.key, required this.text});
  final String text;
  @override
  State<LessonMarkdown> createState() => LessonMarkdownState();
}

class LessonMarkdownState extends State<LessonMarkdown> {
  late List<md.Node> _nodes;
  final List<GlobalKey> _anchors = [];
  final Set<md.Node> _expandedOptional = {};
  @override
  void initState() {
    super.initState();
    _parse();
  }

  @override
  void didUpdateWidget(LessonMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) _parse();
  }

  void _parse() {
    _nodes = _parseMarkdown(widget.text);
    _anchors.clear();
    _expandedOptional.clear();
    for (final node in _nodes) {
      if (node is md.Element && RegExp(r'^h[1-6]$').hasMatch(node.tag)) {
        _anchors.add(GlobalKey());
      }
    }
  }

  Future<void> jumpTo(int heading, {bool animate = true}) async {
    if (heading < 0 || heading >= _anchors.length) return;
    final context = _anchors[heading].currentContext;
    if (context != null) {
      await Scrollable.ensureVisible(
        context,
        alignment: 0.08,
        duration: animate ? const Duration(milliseconds: 180) : Duration.zero,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var heading = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final node in _nodes)
          _block(
            context,
            node,
            key: node is md.Element && RegExp(r'^h[1-6]$').hasMatch(node.tag)
                ? _anchors[heading++]
                : null,
          ),
      ],
    );
  }

  Widget _block(BuildContext context, md.Node node, {Key? key}) {
    if (node is md.Text) return _paragraph(context, [node], key: key);
    if (node is! md.Element) return const SizedBox.shrink();
    final children = node.children ?? const <md.Node>[];
    switch (node.tag) {
      case 'h1':
      case 'h2':
      case 'h3':
      case 'h4':
      case 'h5':
      case 'h6':
        return Padding(
          key: key,
          padding: const EdgeInsets.only(top: 26, bottom: 12),
          child: Semantics(
            header: true,
            child: SelectableText(
              node.textContent,
              style: TextStyle(
                fontSize: node.tag == 'h1'
                    ? 24
                    : node.tag == 'h2'
                    ? 20
                    : 17,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: Design.ink(context),
              ),
            ),
          ),
        );
      case 'pre':
        final code = children
            .whereType<md.Element>()
            .where((e) => e.tag == 'code')
            .firstOrNull;
        final language =
            code?.attributes['class']?.replaceFirst('language-', '') ?? 'text';
        var source = code?.textContent ?? node.textContent;
        if (source.endsWith('\n')) {
          source = source.substring(0, source.length - 1);
        }
        return CodeBlock(
          code: source,
          language: language,
          caption: language == 'java' ? 'Java' : language,
        );
      case 'ul':
      case 'ol':
        var index = int.tryParse(node.attributes['start'] ?? '1') ?? 1;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in children.whereType<md.Element>())
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 26,
                        child: Text(
                          node.tag == 'ol' ? '${index++}.' : '•',
                          style: TextStyle(
                            height: 1.7,
                            fontSize: 15,
                            color: Design.accentFor(context),
                          ),
                        ),
                      ),
                      Expanded(child: _listItem(context, item)),
                    ],
                  ),
                ),
            ],
          ),
        );
      case 'blockquote':
        final first = children.firstOrNull;
        const optionalMarker = '[!OPTIONAL] ';
        if (first is md.Element &&
            first.tag == 'p' &&
            first.textContent.startsWith(optionalMarker) &&
            children.length > 1) {
          final title = first.textContent
              .substring(optionalMarker.length)
              .trim();
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Expander(
              key: ValueKey(node),
              animationDuration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              onStateChanged: (expanded) => setState(() {
                if (expanded) {
                  _expandedOptional.add(node);
                } else {
                  _expandedOptional.remove(node);
                }
              }),
              header: Semantics(
                expanded: _expandedOptional.contains(node),
                child: Text(
                  'Dobrovolně · $title',
                  softWrap: true,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children
                    .skip(1)
                    .map((n) => _block(context, n))
                    .toList(),
              ),
            ),
          );
        }
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children.map((n) => _block(context, n)).toList(),
          ),
        );
      case 'hr':
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(),
        );
      case 'table':
        return _table(context, node);
      case 'p':
        return _paragraph(context, children, key: key);
      default:
        // Render unsupported elements as text.
        return _paragraph(
          context,
          children.isEmpty ? [md.Text(node.textContent)] : children,
          key: key,
        );
    }
  }

  Widget _listItem(BuildContext context, md.Element element) {
    final nodes = element.children ?? [];
    if (nodes.any(
      (n) => n is md.Element && {'p', 'ul', 'ol', 'pre'}.contains(n.tag),
    )) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: nodes.map((n) => _block(context, n)).toList(),
      );
    }
    return _paragraph(context, nodes, bottom: 0);
  }

  Widget _paragraph(
    BuildContext context,
    List<md.Node> nodes, {
    Key? key,
    double bottom = 14,
  }) => Padding(
    key: key,
    padding: EdgeInsets.only(bottom: bottom),
    child: SelectableText.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.75,
          color: Design.ink(context),
        ),
        children: nodes.map((n) => _span(context, n)).toList(),
      ),
    ),
  );

  InlineSpan _span(BuildContext context, md.Node node) {
    if (node is md.Text) return TextSpan(text: node.text);
    if (node is! md.Element) return const TextSpan();
    if (node.tag == 'br') return const TextSpan(text: '\n');
    if (node.tag == 'img') return TextSpan(text: node.attributes['alt'] ?? '');
    if (node.tag == 'a') {
      final uri = Uri.tryParse(node.attributes['href'] ?? '');
      final app = LessonLinks.of(context);
      if (uri?.scheme == 'lesson' &&
          app?.course.lessonsById.containsKey(uri!.path) == true) {
        return WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: HyperlinkButton(
            key: ValueKey('lesson-link-${uri!.path}'),
            onPressed: () => app!.openReference(uri.path),
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
            ),
            child: Text(
              node.textContent,
              // WidgetSpan already scales its entire child with the paragraph.
              textScaler: TextScaler.noScaling,
              softWrap: true,
              maxLines: 10,
              style: const TextStyle(
                fontSize: 15,
                height: 1.75,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }
      return TextSpan(text: node.textContent);
    }
    final TextStyle? style = switch (node.tag) {
      'strong' => const TextStyle(fontWeight: FontWeight.w600),
      'em' => const TextStyle(fontStyle: FontStyle.italic),
      'del' => const TextStyle(decoration: TextDecoration.lineThrough),
      'code' => TextStyle(
        fontFamily: Design.mono,
        fontSize: 13,
        color: Design.accentFor(context),
        backgroundColor: Design.accentFor(context).withValues(alpha: 0.07),
      ),
      'a' => TextStyle(
        color: Design.accentFor(context),
        decoration: TextDecoration.underline,
      ),
      _ => null,
    };
    return TextSpan(
      style: style,
      children: (node.children ?? <md.Node>[])
          .map((n) => _span(context, n))
          .toList(),
    );
  }

  Widget _table(BuildContext context, md.Element table) {
    final rows = <md.Element>[];
    void findRows(md.Node n) {
      if (n is md.Element) {
        if (n.tag == 'tr') {
          rows.add(n);
          return;
        }
        for (final child in n.children ?? <md.Node>[]) {
          findRows(child);
        }
      }
    }

    findRows(table);
    final count = rows.fold<int>(
      0,
      (n, r) => (r.children?.length ?? 0) > n ? r.children!.length : n,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          border: TableBorder.all(color: Design.border(context)),
          children: [
            for (final row in rows)
              TableRow(
                children: [
                  for (var i = 0; i < count; i++)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SelectableText(
                        i < (row.children?.length ?? 0)
                            ? row.children![i].textContent
                            : '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Design.ink(context),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

List<md.Node> _parseMarkdown(String text) => md.Document(
  encodeHtml: false,
  extensionSet: md.ExtensionSet.gitHubFlavored,
).parseLines(text.replaceAll('\r\n', '\n').split('\n'));

// Match reading anchors, excluding headings in code blocks and optional boxes.
List<String> markdownHeadings(String text) => _parseMarkdown(text)
    .whereType<md.Element>()
    .where((node) => RegExp(r'^h[1-6]$').hasMatch(node.tag))
    .map((node) => node.textContent)
    .toList();
