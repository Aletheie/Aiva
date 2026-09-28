## Od ručního průchodu k popisu výsledku

Navážeme na jmenovky: ze seznamu vybereme jména dlouhá alespoň čtyři znaky a zjistíme jejich délky. S cyklem napíšeme každý krok zvlášť — vytvoření výsledku, průchod, podmínku a přidání hodnoty. Tomu se říká **imperativní styl (imperative style)**.

Stream API umožní zapsat návaznost operací: vyber jména, převeď je na délky, vytvoř seznam. Takový **deklarativní styl (declarative style)** se soustředí na požadovaný výsledek. Stream přitom data sám neuchovává jako nová kolekce; popisuje jejich zpracování.

Potřebuješ [kolekce](lesson:collections-overview) a [lambdy](lesson:lambdas-overview). Příkazy `filter`, `map` a další si vyzkoušíme na stejných datech, aby šlo sledovat každou změnu.

## Dvě rovnocenná řešení

Celý program v `Main.java`:

```java
import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<String> names = List.of("Ada", "Eliška", "Eva", "Eliška");
        List<Integer> lengths = new ArrayList<>();
        for (String name : names) {
            if (name.length() >= 4) {
                lengths.add(name.length());
            }
        }
        System.out.println(lengths); // [6, 6]

        List<Integer> streamed = names.stream()
                .filter(name -> name.length() >= 4)
                .map(String::length)
                .toList();
        System.out.println(streamed); // [6, 6]
    }
}
```

`stream()` vytvoří stream nad seznamem. `filter(Predicate)` ponechá prvky, pro které pravidlo vrátí `true`. Nemění jejich hodnoty. Ada a Eva mají po třech písmenech, takže neprojdou. Po filtru zbývá Eliška dvakrát; samotný filtr opakování neodstraňuje. `map(Function)` převede každý prvek; `String::length` je totéž co `name -> name.length()`. Po mapování máme dvě čísla 6. `toList()` průchod dokončí a vrátí **neměnitelný** seznam. Původní `names` zůstane stejný.

## Zpracování začne až při vyžádání výsledku

Posloupnosti zdroj → mezikroky → zakončení říkáme **pipeline**. `filter`, `map`, `sorted`, `distinct` a `limit` jsou mezilehlé operace: vracejí další stream. Samotné sestavení pipeline běžně neprojde data; práci spustí až terminální operace, například `toList`, `count`, `collect` nebo `reduce`. To je **lazy evaluation**, odložené vyhodnocení.

Stream spotřebuješ jedním zakončením. Pro druhý výsledek zavolej na zdroji nové `stream()`. Uložení do proměnné a dvě terminální volání nad stejným streamem je chyba. V lambdách neměň kolekci, kterou současně stream prochází.

## Vyzkoušej další mezikroky

Tento úryvek patří do `main` předchozího programu:

```java
List<String> selected = names.stream()
        .distinct()
        .sorted()
        .limit(2)
        .toList();
System.out.println(selected); // [Ada, Eliška]
```

`distinct()` odstraňuje duplicity podle `equals`, `sorted()` řadí přirozeně a `limit(2)` vezme nejvýše dva prvky. Pořadí operací má význam. U seznamu `Zoe, Eva, Ada` by `limit(2)` před řazením ponechalo Zoe a Evu; výsledkem by bylo `Eva, Zoe`. Řazení před limitem naopak vybere `Ada, Eva`. `skip(1)` přeskočí první prvek. Přirozené řazení `String` není lokalizovaná česká abeceda.

`flatMap` spojí více vnořených sekvencí: `List.of(List.of(1, 2), List.of(3)).stream().flatMap(List::stream).toList()` vrátí `[1, 2, 3]`. Na rozdíl od `map` tedy z každého prvku získá stream a jeho obsah vloží do jedné výsledné posloupnosti. `List::stream` volá metodu `stream()` každého vnitřního seznamu.

## Redukce na jednu hodnotu

```java
int sum = List.of(2, 3, 4).stream().reduce(0, (total, value) -> total + value);
long count = names.stream().filter(name -> name.startsWith("E")).count();
int letters = names.stream().mapToInt(String::length).sum();
System.out.println(sum);     // 9
System.out.println(count);   // 3
System.out.println(letters); // 18
```

`reduce` kombinuje prvky: 0+2, 2+3, 5+4. První argument `0` je neutrální počáteční hodnota, takže prázdný stream dá 0. Sčítání je asociativní; odčítání by pro obecnou redukci s rozdělením práce takové pravidlo nesplnilo. `count()` vrací `long`, i když je seznam krátký. `mapToInt` vytváří číselný `IntStream`, jeho `sum()` sečte hodnoty bez obalování každého výsledku. Analogický `mapToLong` používá `long`.

`anyMatch(pravidlo)` vrátí, zda některý prvek vyhovuje, `allMatch` zda všechny, `noneMatch` zda žádný. Na prázdném streamu je `anyMatch` false a zbývající dvě true. Tyto operace mohou skončit, jakmile znají odpověď.

## collect a seskupování

Přidej importy `java.util.Map` a `java.util.stream.Collectors`. Do `main`:

```java
List<String> editable = names.stream()
        .filter(name -> name.length() > 3)
        .collect(Collectors.toCollection(ArrayList::new));
Map<Integer, List<String>> byLength = names.stream()
        .collect(Collectors.groupingBy(String::length));
String joined = names.stream().collect(Collectors.joining(", "));
System.out.println(byLength.get(3)); // [Ada, Eva]
System.out.println(joined); // Ada, Eliška, Eva, Eliška
```

`collect(collector)` používá popis, jak sestavit výsledek. `toCollection(ArrayList::new)` výslovně vytváří měnitelný `ArrayList`; odkaz na konstruktor dodá prázdnou cílovou kolekci. `Collectors.toList()` také vytváří seznam, ale nezaručuje konkrétní typ seznamu ani to, že půjde měnit. Nezaměňuj ho s `Stream.toList()`, které měnitelnost výslovně zakazuje.

`groupingBy(String::length)` udělá mapu délka → seznam jmen. `joining(", ")` spojí texty oddělovačem. `groupingBy(String::length, Collectors.counting())` místo seznamů vytvoří počty typu `Long`. `Collectors.toMap(klíčováFunkce, hodnotováFunkce)` vytváří mapu, ale při duplicitních klíčích bez slučovacího pravidla selže; pro opakující se hodnoty zde raději seskupujeme.

## Optional a neexistující výsledek

`findFirst()` vrací `Optional<T>`, obal pro přítomnou nebo chybějící hodnotu. Například `names.stream().filter(n -> n.startsWith("Z")).findFirst().orElse("Nenalezeno")` vrátí náhradní text. `orElse` poskytuje hotovou hodnotu, `orElseGet(() -> "host")` ji získá z funkce až při absenci. `isPresent()` zjistí přítomnost; `ifPresent(System.out::println)` provede akci jen tehdy, když hodnota existuje. Slepé `get()` bez kontroly může vyvolat `NoSuchElementException`.

## Stream nad souborem

S importy `java.nio.file.Files`, `java.nio.file.Path`, `java.nio.charset.StandardCharsets`, `java.util.stream.Stream` a `java.io.IOException` lze v `main` použít:

```java
try (Stream<String> lines = Files.lines(Path.of("names.txt"), StandardCharsets.UTF_8)) {
    long nonEmpty = lines.filter(line -> !line.isBlank()).count();
    System.out.println(nonEmpty);
} catch (IOException | java.io.UncheckedIOException error) {
    System.out.println("Čtení selhalo: " + error.getMessage());
}
```

Vytvoř `names.txt` s řádky Ada, prázdný řádek a Eva: výsledek je `2`. Souborový stream musí být uzavřen, proto `try-with-resources`. Otevření může vyhodit `IOException`, pozdější čtení při průchodu `UncheckedIOException`, tedy obal vstupně-výstupní chyby bez povinného zachycení.

Stream není automaticky rychlejší než cyklus. `parallelStream()` rozděluje práci a přidává nároky na bezpečnost sdíleného stavu; pro tyto úlohy používej běžný sekvenční stream. `peek` je průběžná pozorovací operace, ale její vedlejší účinky mohou být kvůli optimalizaci vynechány. Povinnou práci proto neschovávej do `peek` ani do filtru. Když je cyklus čitelnější, použij ho.

> [!OPTIONAL] Pod povrch: kdy stream potřebuje paměť
>
> Filtr a mapování lze zpracovávat postupně pro jeden prvek po druhém, bez vytváření samostatného meziseznamu pro každý krok. `sorted` naopak typicky potřebuje shromáždit data před vydáním seřazeného výsledku; `distinct` potřebuje sledovat již viděné hodnoty. „Stream“ tedy neznamená nulovou paměť ani automatické zvládnutí nekonečného zdroje.
>
> Krátké zakončení, například findFirst, může zdroj projít jen částečně. Optimalizace navíc smí vynechat kroky, jejichž provedení nemění výsledek. Proto do mapování ani peek neschovávej povinné ukládání nebo počítání vedlejších účinků. Sekvenční proud stále poskytuje dobrý model toku hodnot; výkon ověřuj měřením s reálnými daty, ne délkou zápisu.

## Součty podle kategorií v projektu

Analyzátor výdajů používá `Collectors.groupingBy(Expense::category, Collectors.summingLong(Expense::cents))`. `Expense::category` určí klíč skupiny, `summingLong` načte částku každého prvku jako long a sečte částky uvnitř jedné skupiny. Výsledný typ je `Map<String, Long>`. Například dvě položky Jídlo s 1200 a 800 haléři dají pod klíčem Jídlo hodnotu 2000. Běžný long součet může přetéct, proto vstupní rozsah musí odpovídat zadání.

`totals.forEach((category, cents) -> System.out.println(category + ": " + cents))` je metoda mapy: předává lambdě dva argumenty, klíč a hodnotu. Není to totéž jako jednoargumentová akce nad prvky seznamu. Její pořadí závisí na konkrétní mapě. `Integer::sum` je odkaz na statickou metodu sčítající dva int a odpovídá `(a, b) -> a + b`; s neutrální nulou se hodí do reduce.
