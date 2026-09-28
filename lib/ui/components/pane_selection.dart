import 'package:fluent_ui/fluent_ui.dart';

/// Keeps one selection bar alive while Fluent rebuilds the selected pane item.
class PaneSelection extends StatefulWidget {
  const PaneSelection({
    super.key,
    required this.selected,
    required this.builder,
  });

  final int selected;
  final Widget Function(Widget indicator) builder;

  @override
  State<PaneSelection> createState() => _PaneSelectionState();
}

class _PaneSelectionState extends State<PaneSelection>
    with SingleTickerProviderStateMixin {
  final _surfaceKey = GlobalKey();
  final _targetKey = GlobalKey();
  late final _motion = AnimationController(vsync: this, value: 1);
  final _geometryVersion = ValueNotifier(0);
  late final _indicatorUpdates = Listenable.merge([_motion, _geometryVersion]);
  // Logical pixels per second, shared by adjacent items and the distant footer.
  static const _travelSpeed = 900.0;
  RectTween? _position;
  Rect? _visibleBounds;
  int? _selection;
  bool _scheduled = false;

  Rect? get _current => _position?.transform(_motion.value);

  void _schedulePosition() {
    if (_scheduled || !mounted) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (mounted) _updatePosition();
    });
  }

  void _updatePosition() {
    final target = _targetKey.currentContext?.findRenderObject();
    final surface = _surfaceKey.currentContext?.findRenderObject();
    if (target is! RenderBox ||
        !target.attached ||
        !target.hasSize ||
        surface is! RenderBox ||
        !surface.attached ||
        !surface.hasSize) {
      if (_position != null) {
        _motion.stop();
        _position = null;
        _geometryVersion.value++;
      }
      return;
    }

    final origin = target.localToGlobal(Offset.zero, ancestor: surface);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final destination = Rect.fromLTWH(
      origin.dx + (rtl ? target.size.width - 9 : 6),
      origin.dy + (target.size.height - 20) / 2,
      3,
      20,
    );

    // A scrolled-out item must not leave its bar over the pane header/footer.
    var visibleBounds = Offset.zero & surface.size;
    RenderObject child = target;
    while (child.parent != null) {
      final parent = child.parent!;
      final clip = parent.describeApproximatePaintClip(child);
      if (clip != null) {
        visibleBounds = visibleBounds.intersect(
          MatrixUtils.transformRect(parent.getTransformTo(surface), clip),
        );
      }
      if (parent == surface) break;
      child = parent;
    }

    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final changedSelection = _selection != widget.selected;
    _selection = widget.selected;
    if (_position?.end == destination &&
        _visibleBounds == visibleBounds &&
        !(reducedMotion && _motion.isAnimating)) {
      return;
    }

    final current = _current;
    final animate =
        current != null &&
        !reducedMotion &&
        (changedSelection || _motion.isAnimating);
    _position = RectTween(
      begin: animate ? current : destination,
      end: destination,
    );
    _visibleBounds = visibleBounds;
    if (animate) {
      // Keep the visible position when a click, scroll or resize moves the
      // destination during travel; shifting the whole tween makes the bar jump.
      final distance = (destination.center - current.center).distance;
      _motion.duration = Duration(
        microseconds: (distance * Duration.microsecondsPerSecond / _travelSpeed)
            .round(),
      );
      _motion.forward(from: 0);
    } else {
      _motion.value = 1;
    }
    // Measuring the bar must not rebuild the navigation pane and page content.
    _geometryVersion.value++;
  }

  @override
  void dispose() {
    _motion.dispose();
    _geometryVersion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _schedulePosition();
    final color = NavigationPaneTheme.of(context).highlightColor!;
    return NotificationListener<ScrollNotification>(
      onNotification: (_) {
        _schedulePosition();
        return false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          _schedulePosition();
          return Stack(
            key: _surfaceKey,
            children: [
              widget.builder(
                _SelectionAnchor(
                  targetKey: _targetKey,
                  onLayout: _schedulePosition,
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: _indicatorUpdates,
                        child: Container(
                          key: const ValueKey('navigation-selection'),
                          width: 3,
                          height: 20,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(1.5),
                          ),
                        ),
                        builder: (context, child) => _current == null
                            ? const SizedBox.shrink()
                            : ClipRect(
                                clipper: _SelectionClipper(
                                  _motion.isAnimating ? null : _visibleBounds,
                                ),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Transform.translate(
                                    offset: _current!.topLeft,
                                    child: child,
                                  ),
                                ),
                              ),
                      ),
                    ),
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

class _SelectionAnchor extends NavigationIndicator {
  const _SelectionAnchor({required this.targetKey, required this.onLayout});
  final GlobalKey targetKey;
  final VoidCallback onLayout;

  @override
  NavigationIndicatorState<_SelectionAnchor> createState() =>
      _SelectionAnchorState();
}

class _SelectionAnchorState extends NavigationIndicatorState<_SelectionAnchor> {
  @override
  Widget build(BuildContext context) {
    widget.onLayout();
    return isSelected
        ? SizedBox.expand(key: widget.targetKey)
        : const SizedBox.shrink();
  }

  @override
  void dispose() {
    widget.onLayout();
    super.dispose();
  }
}

class _SelectionClipper extends CustomClipper<Rect> {
  const _SelectionClipper(this.bounds);
  final Rect? bounds;

  @override
  Rect getClip(Size size) => bounds ?? Offset.zero & size;

  @override
  bool shouldReclip(_SelectionClipper oldClipper) =>
      bounds != oldClipper.bounds;
}

/// Adds four points to Fluent's six-point margins.
mixin _PaneInset on PaneItem {
  @override
  Widget build({
    required BuildContext context,
    required bool selected,
    required VoidCallback? onPressed,
    required PaneDisplayMode? displayMode,
    required int itemIndex,
    bool? autofocus,
    bool showTextOnTop = true,
    int depth = 0,
  }) => Padding(
    padding: EdgeInsets.symmetric(
      horizontal: displayMode == PaneDisplayMode.compact ? 0 : 4,
    ),
    child: super.build(
      context: context,
      selected: selected,
      onPressed: onPressed,
      displayMode: displayMode,
      itemIndex: itemIndex,
      autofocus: autofocus,
      showTextOnTop: showTextOnTop,
      depth: depth,
    ),
  );
}

class InsetPaneItem extends PaneItem with _PaneInset {
  InsetPaneItem({
    super.key,
    super.icon,
    super.title,
    super.body,
    super.focusNode,
    super.onTap,
  });
}

class InsetPaneItemAction extends PaneItemAction with _PaneInset {
  InsetPaneItemAction({
    super.key,
    super.focusNode,
    super.icon,
    super.title,
    super.tileColor,
    super.trailing,
    required super.onTap,
  });
}
