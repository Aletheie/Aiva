import 'package:fluent_ui/fluent_ui.dart';
import '../design.dart';

/// Shared spacing only; Fluent owns the surface, border and control states.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
    this.borderColor,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) => Card(
    padding: padding,
    backgroundColor: color,
    borderColor: borderColor,
    borderRadius: BorderRadius.circular(Design.radius),
    child: child,
  );
}

class PageTitle extends StatelessWidget {
  const PageTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });
  final String title;
  final String? subtitle;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          padding: 0,
          title: Semantics(header: true, child: Text(title)),
        ),
        if (subtitle case final text?)
          Text(
            text,
            style: TextStyle(color: Design.muted(context), height: 1.5),
          ),
        if (trailing case final action?) ...[
          const SizedBox(height: 16),
          action,
        ],
      ],
    ),
  );
}

class PageScroll extends StatefulWidget {
  const PageScroll({
    super.key,
    required this.children,
    this.controller,
    this.maxWidth = Design.pageWidth,
  });
  final List<Widget> children;
  final ScrollController? controller;
  final double maxWidth;
  @override
  State<PageScroll> createState() => _PageScrollState();
}

class _PageScrollState extends State<PageScroll> {
  final _ownedController = ScrollController();
  ScrollController get controller => widget.controller ?? _ownedController;
  @override
  void dispose() {
    _ownedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final horizontal = constraints.maxWidth < 700 ? 20.0 : 36.0;
      return Scrollbar(
        controller: controller,
        child: SingleChildScrollView(
          controller: controller,
          padding: EdgeInsets.fromLTRB(horizontal, 28, horizontal, 36),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: widget.maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.children,
              ),
            ),
          ),
        ),
      );
    },
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.subtitle, this.trailing});
  final String title;
  final String? subtitle;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 28, bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  title,
                  style: FluentTheme.of(context).typography.subtitle,
                ),
              ),
            ),
            if (trailing case final action?) ...[
              const SizedBox(width: 16),
              action,
            ],
          ],
        ),
        if (subtitle case final text?) ...[
          const SizedBox(height: 6),
          Text(text, style: TextStyle(color: Design.muted(context))),
        ],
      ],
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.action,
  });
  final String title;
  final String message;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            title,
            style: FluentTheme.of(context).typography.subtitle,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          message,
          style: TextStyle(color: Design.muted(context), height: 1.5),
        ),
        if (action case final button?) ...[const SizedBox(height: 20), button],
      ],
    ),
  );
}
