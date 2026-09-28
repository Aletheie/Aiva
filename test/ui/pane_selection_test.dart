import 'package:aiva/ui/components/pane_selection.dart';
import 'package:aiva/ui/design.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final indicator = find.byKey(const ValueKey('navigation-selection'));
  Finder item(int index) => find.byKey(ValueKey('item-$index'));

  Future<void> showPane(
    WidgetTester tester, {
    bool reducedMotion = false,
    PaneDisplayMode mode = PaneDisplayMode.expanded,
    double height = 600,
  }) async {
    tester.view.physicalSize = Size(1000, height);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    var selected = 0;
    await tester.pumpWidget(
      FluentApp(
        theme: Design.theme(Brightness.light, reducedMotion: reducedMotion),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(disableAnimations: reducedMotion),
          child: child!,
        ),
        home: StatefulBuilder(
          builder: (context, setState) => PaneSelection(
            selected: selected,
            builder: (indicator) => NavigationView(
              pane: NavigationPane(
                selected: selected,
                onChanged: (index) => setState(() => selected = index),
                displayMode: mode,
                indicator: indicator,
                items: [
                  for (var index = 0; index < 5; index++)
                    InsetPaneItem(
                      key: ValueKey('item-$index'),
                      icon: const Icon(FluentIcons.home),
                      title: Text('Page $index'),
                      body: const SizedBox.shrink(),
                    ),
                ],
                footerItems: [
                  InsetPaneItem(
                    key: const ValueKey('item-5'),
                    icon: const Icon(FluentIcons.settings),
                    title: const Text('Settings'),
                    body: const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final mode in [PaneDisplayMode.expanded, PaneDisplayMode.compact]) {
    testWidgets('selection moves continuously and can reverse in $mode', (
      tester,
    ) async {
      await showPane(tester, mode: mode);
      final start = tester.getCenter(indicator);
      expect(start.dy, tester.getCenter(item(0)).dy);
      expect(
        tester.getRect(item(0)).left,
        mode == PaneDisplayMode.compact ? 6 : 10,
      );

      await tester.tap(item(4));
      await tester.pump();
      await tester.pump();
      expect(tester.getCenter(indicator), start);
      await tester.pump(const Duration(milliseconds: 64));
      final inFlight = tester.getCenter(indicator);
      expect(inFlight.dy, greaterThan(start.dy));
      expect(inFlight.dy, lessThan(tester.getCenter(item(4)).dy));

      await tester.tap(item(0));
      await tester.pump();
      await tester.pump();
      expect(tester.getCenter(indicator), inFlight);
      await tester.pump(const Duration(milliseconds: 64));
      expect(tester.getCenter(indicator).dy, lessThan(inFlight.dy));
      await tester.pumpAndSettle();
      expect(tester.getCenter(indicator), start);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('selection travels at the same speed over different distances', (
    tester,
  ) async {
    await showPane(tester);
    Future<({double distance, double firstStep, double secondStep, int frames})>
    travelTo(int index) async {
      final start = tester.getCenter(indicator).dy;
      final end = tester.getCenter(item(index)).dy;
      await tester.tap(item(index));
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 8));
      final first = tester.getCenter(indicator).dy;
      await tester.pump(const Duration(milliseconds: 8));
      final second = tester.getCenter(indicator).dy;
      var frames = 2;
      while ((tester.getCenter(indicator).dy - end).abs() > 0.01 &&
          frames < 250) {
        await tester.pump(const Duration(milliseconds: 8));
        frames++;
      }
      expect(tester.getCenter(indicator).dy, closeTo(end, 0.01));
      await tester.pumpAndSettle();
      return (
        distance: (end - start).abs(),
        firstStep: (first - start).abs(),
        secondStep: (second - first).abs(),
        frames: frames,
      );
    }

    final nearby = await travelTo(1);
    await travelTo(0);
    final distant = await travelTo(5);
    expect(nearby.firstStep, greaterThan(0));
    expect(nearby.secondStep, closeTo(nearby.firstStep, 0.05));
    expect(distant.firstStep, closeTo(nearby.firstStep, 0.05));
    expect(distant.secondStep, closeTo(nearby.firstStep, 0.05));
    expect(distant.frames, greaterThan(nearby.frames));
    final pixelsPerMillisecond = nearby.firstStep / 8;
    for (final trip in [nearby, distant]) {
      final expectedMilliseconds = trip.distance / pixelsPerMillisecond;
      // Arrival is observed on the first sampled frame after completion.
      expect(
        trip.frames * 8,
        inInclusiveRange(
          expectedMilliseconds - 0.1,
          expectedMilliseconds + 8.1,
        ),
      );
    }
  });

  testWidgets('selection travels to the footer without disappearing', (
    tester,
  ) async {
    await showPane(tester);
    final start = tester.getCenter(indicator).dy;
    await tester.tap(item(5));
    await tester.pump();
    await tester.pump();
    var previous = start;
    for (var frame = 0; frame < 120; frame++) {
      await tester.pump(const Duration(milliseconds: 16));
      expect(indicator, findsOneWidget);
      final position = tester.getCenter(indicator).dy;
      expect(position, greaterThanOrEqualTo(previous));
      expect(position, lessThanOrEqualTo(tester.getCenter(item(5)).dy));
      previous = position;
      if (position == tester.getCenter(item(5)).dy) break;
    }
    expect(previous, tester.getCenter(item(5)).dy);
  });

  testWidgets('resizing during travel retargets without a position jump', (
    tester,
  ) async {
    await showPane(tester);
    await tester.tap(item(5));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 64));
    final inFlight = tester.getCenter(indicator);

    tester.view.physicalSize = const Size(1000, 800);
    await tester.pump();
    await tester.pump();
    expect(tester.getCenter(indicator), inFlight);
    await tester.pump(const Duration(milliseconds: 16));
    expect(tester.getCenter(indicator).dy, greaterThan(inFlight.dy));
    expect(tester.getCenter(indicator).dy - inFlight.dy, lessThan(30));
    await tester.pumpAndSettle();
    expect(tester.getCenter(indicator).dy, tester.getCenter(item(5)).dy);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reduced motion places the selection immediately', (
    tester,
  ) async {
    await showPane(tester, reducedMotion: true);
    await tester.tap(item(4));
    await tester.pump();
    await tester.pump();
    expect(tester.getCenter(indicator).dy, tester.getCenter(item(4)).dy);
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pumpAndSettle();
  });

  testWidgets('selection stays aligned when the pane scrolls or resizes', (
    tester,
  ) async {
    await showPane(tester, height: 240);
    await tester.scrollUntilVisible(
      item(4),
      60,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(item(4));
    await tester.pumpAndSettle();
    expect(tester.getCenter(indicator).dy, tester.getCenter(item(4)).dy);
    await tester.drag(item(2), const Offset(0, 30));
    await tester.pumpAndSettle();
    expect(tester.getCenter(indicator).dy, tester.getCenter(item(4)).dy);

    tester.view.physicalSize = const Size(1000, 450);
    await tester.pumpAndSettle();
    expect(tester.getCenter(indicator).dy, tester.getCenter(item(4)).dy);
    expect(tester.takeException(), isNull);
  });
}
