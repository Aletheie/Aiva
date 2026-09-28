## Předáme pravidlo pro výběr jmen

Leslie chystá jmenovky na sousedskou akci. Delší jména chce vypsat zvlášť, aby zkontrolovala, jestli se vejdou. Program proto projde seznam a každé jméno posoudí podle pravidla, které mu předáme. **Lambda výraz (lambda expression)** je krátký zápis právě takového pravidla.

Lambda musí odpovídat **funkčnímu rozhraní (functional interface)**, tedy rozhraní s jednou abstraktní metodou. Stále tak víme, jaký vstup dostane a jaký výsledek vrátí. Základ vysvětluje [lekce rozhraní](lesson:interfaces-overview).

## Výběr podle délky

Celý program v `Main.java`:

```java
import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;

public class Main {
    static List<String> select(List<String> names, Predicate<String> rule) {
        List<String> result = new ArrayList<>();
        for (String name : names) {
            if (rule.test(name)) {
                result.add(name);
            }
        }
        return result;
    }

    public static void main(String[] args) {
        List<String> names = List.of("Ada", "Eliška", "Eva");
        int minimumLength = 4;
        List<String> longNames = select(names, name -> name.length() >= minimumLength);
        System.out.println(longNames); // [Eliška]
    }
}
```

`Predicate<String>` je standardní funkční rozhraní s metodou `boolean test(String value)`. Naše `select` nepotřebuje vědět, jaké konkrétní pravidlo dostane; pro každé jméno zavolá `rule.test(name)` a při `true` ho přidá do nového seznamu.

`name -> name.length() >= minimumLength` se čte „vezmi jméno a vrať, zda má požadovanou délku“. Levá strana uvádí parametr, šipka odděluje tělo. Typ `String` překladač odvodí z `Predicate<String>`. `length()` vrací počet UTF-16 jednotek textu; pro tato jména odpovídá počtu běžných písmen. Lambda vstupní seznam nemění.

## Krátké a blokové tělo

Výrazová lambda výsledek implicitně vrátí. Stejné pravidlo lze rozepsat:

```java
Predicate<String> longEnough = (String name) -> {
    int length = name.length();
    return length >= 4;
};
System.out.println(longEnough.test("Ada")); // false
```

Tento úryvek patří do `main`. Více příkazů vyžaduje složené závorky a u návratové hodnoty explicitní `return`. Lambda bez parametrů má `() -> ...`, s více parametry například `(left, right) -> left + right`.

## Čtyři druhy předávaných operací

S odpovídajícími importy z `java.util.function` můžeš v `main` vyzkoušet:

| Typ a příklad | Volaná metoda | Smysl |
|---|---|---|
| `Predicate<String> p = text -> text.isBlank();` | `p.test(" ")` → `true` | Otázka ano/ne |
| `Function<String, Integer> f = text -> text.length();` | `f.apply("Ada")` → `3` | Převod vstupu na výstup |
| `Consumer<String> c = text -> System.out.println(text);` | `c.accept("Ada")` vypíše jméno | Akce bez návratové hodnoty |
| `Supplier<String> s = () -> "host";` | `s.get()` → `"host"` | Hodnota bez vstupního argumentu |

`Function<T,R>` má vstupní a výsledný typ; pro počet používá obalový `Integer` kvůli generikům. `Consumer` může mít vedlejší účinek, například výpis. Samotné vytvoření lambdy ještě její tělo neprovede; to nastane při `test`, `apply`, `accept` nebo `get`.

Vlastní funkční rozhraní může vypadat `@FunctionalInterface interface PriceRule { int apply(int price); }`. Anotace požádá překladač, aby jednu abstraktní metodu ověřil. Výchozí nebo statické metody navíc nejsou překážkou.

## Zachycené proměnné

`minimumLength` je proměnná z okolí lambdy. Lokální zachycená proměnná musí být `final` nebo **effectively final**: po přiřazení už se nepřiřazuje znovu. Přidání `minimumLength++` by ukázku rozbilo při překladu. Jde o stabilitu zachycené hodnoty, nikoli o zmrazení objektu: zachycený seznam by stále mohl být měnitelný. Sdílené měnění seznamů v lambdách ale často dělá tok dat nepřehledný.

## Odkaz na metodu

Když lambda pouze předává argument existující metodě, lze napsat **method reference**: `String::length` odpovídá `text -> text.length()`, `System.out::println` odpovídá `text -> System.out.println(text)`. Zápis `::` metodu hned nevolá; vytváří chování pro pozdější volání. `Integer::parseInt` je odkaz na statickou metodu, `ArrayList::new` na konstruktor vytvářející seznam.

U kolekcí můžeš použít `names.forEach(System.out::println)`: `forEach` zavolá předaný `Consumer` na každý prvek. `mutableNames.removeIf(name -> name.isBlank())` odstraní prvky odpovídající `Predicate`; na neměnitelném `List.of(...)` by mazání selhalo.

Přepiš pravidlo v `select` na `name -> name.startsWith("E")`. `startsWith` vrací, zda text začíná uvedenými znaky; čekej `[Eliška, Eva]`. Průchod seznamem nemusíš měnit. Tím jsi připravena na [Stream API](lesson:streams-overview).

> [!OPTIONAL] Pod povrch: lambda je typovaná hodnota
>
> Lambda se překládá podle cílového funkčního rozhraní. Na úrovni JVM může být její vytvoření zajištěno instrukcí `invokedynamic`, která umožní připojit konkrétní provedení volání. Není pravidlem, že každý zápis lambdy musí vždy vytvořit nový samostatný objekt s novou identitou.
>
> Proto neporovnávej dvě lambdy přes `==` jako důkaz stejného chování. Zachycená lokální hodnota musí být effectively final, ale referencovaný objekt může zůstat měnitelný. Pokud do lambdy zachytíš seznam a někdo ho mezitím změní, předvídatelnost tím nezískáš automaticky.
