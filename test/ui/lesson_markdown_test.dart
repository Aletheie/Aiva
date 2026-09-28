import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aiva/ui/components/code_block.dart';
import 'package:aiva/ui/components/lesson_markdown.dart';

void main() {
  test(
    'reading navigation ignores headings inside code and optional boxes',
    () {
      const text = '''
## Hlavní výklad

```text
# README příklad
```

> [!OPTIONAL] Pod povrch
>
> ## Vnitřní detail
>
> Text navíc.

## Další **část**
''';
      expect(markdownHeadings(text), ['Hlavní výklad', 'Další část']);
    },
  );

  testWidgets(
    'optional details expand by keyboard and reset for a new lesson',
    (tester) async {
      const source = '''
## Hlavní výklad

Základ zůstává viditelný.

> [!OPTIONAL] Pod povrch: reference a paměť objektů
>
> Dvě reference mohou mířit na jeden objekt.
>
> ```java
> int value = 3;
> System.out.println(value);
> ```
''';
      final text = ValueNotifier(source);
      addTearDown(text.dispose);
      await tester.pumpWidget(
        FluentApp(
          home: MediaQuery(
            data: const MediaQueryData(
              textScaler: TextScaler.linear(1.6),
              disableAnimations: true,
            ),
            child: ScaffoldPage(
              content: SingleChildScrollView(
                child: Center(
                  child: SizedBox(
                    width: 400,
                    child: ValueListenableBuilder<String>(
                      valueListenable: text,
                      builder: (context, value, _) =>
                          LessonMarkdown(text: value),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final expander = find.byType(Expander);
      expect(expander, findsOneWidget);
      expect(
        tester.widget<Expander>(expander).animationDuration,
        Duration.zero,
      );
      expect(find.textContaining('[!OPTIONAL]'), findsNothing);
      expect(find.byType(CodeBlock).hitTestable(), findsNothing);

      final button = find
          .descendant(of: expander, matching: find.byType(HoverButton))
          .first;
      final focus = Focus.of(
        tester.element(
          find.descendant(of: button, matching: find.byType(Text)).first,
        ),
      );
      focus.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(tester.state<ExpanderState>(expander).isExpanded, isTrue);
      await tester.ensureVisible(find.byType(CodeBlock));
      await tester.pumpAndSettle();
      expect(find.byType(CodeBlock).hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);

      // A new lesson must not inherit the previous lesson's expanded details.
      text.value = source.replaceFirst(
        'reference a paměť objektů',
        'jiná lekce',
      );
      await tester.pumpAndSettle();
      expect(tester.state<ExpanderState>(expander).isExpanded, isFalse);
      expect(find.byType(CodeBlock).hitTestable(), findsNothing);
      await tester.ensureVisible(
        find.text('Dobrovolně · Pod povrch: jiná lekce'),
      );
      await tester.tap(find.text('Dobrovolně · Pod povrch: jiná lekce'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byType(CodeBlock));
      await tester.pumpAndSettle();
      expect(find.byType(CodeBlock).hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
