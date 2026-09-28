## Nenalezení může být normální výsledek

Katalog obsahuje Emmu pod číslem 1 a Malého prince pod číslem 2. Dotaz na číslo 99 nemá odpověď, což je při hledání běžné. Metoda proto může vrátit **Optional<T>**: buď nalezenou hodnotu, nebo prázdný výsledek. Možnost nenalezení pak vidíš přímo v návratovém typu. Samotný `Optional` nemá být `null`; prázdný výsledek už umí vyjádřit pomocí `Optional.empty()`.

Celý `Main.java` ukazuje tři různé odpovědi katalogu:

```java
import java.util.Map;
import java.util.Optional;

public class Main {
    static Optional<String> findTitle(Map<Integer, String> books, int id) {
        return Optional.ofNullable(books.get(id));
    }

    public static void main(String[] args) {
        Map<Integer, String> books = Map.of(1, "Emma", 2, "Maly princ");
        String title = findTitle(books, 1).orElse("Nenalezeno");
        String missing = findTitle(books, 99).orElse("Nenalezeno");
        Optional<Integer> length = findTitle(books, 2).map(String::length);
        System.out.println(title); // Emma
        System.out.println(missing); // Nenalezeno
        System.out.println(length.orElse(0)); // 10
    }
}
```

`Optional.ofNullable` převede existující objekt na přítomnou hodnotu a `null` na prázdný Optional. `Optional.of(value)` naopak vyžaduje existující objekt. `Optional.empty()` vytváří prázdný výsledek. Ani jedna varianta ale sama neověří název knihy: třeba prázdný text je pořád existující hodnota.

## Převod a filtrování

`map` provede funkci jen při přítomné hodnotě; nepřítomnost se přenese dál. `filter(title -> !title.isBlank())` přítomnou hodnotu zachová jen tehdy, pokud splňuje podmínku. Prázdný řetězec totiž sám o sobě není prázdným Optional. Je potřeba rozhodnout, zda jej aplikace připouští.

Pokud převáděcí funkce sama vrací Optional, obyčejné map by vytvořilo obal v obalu. `flatMap` tyto dvě úrovně spojí. Například metoda hledající autora podle knihy může vracet Optional<Author>; následné flatMap vyjadřuje, že nemusí existovat ani kniha, ani její autor. Tato funkce musí vrátit `Optional`, případně `Optional.empty()`. Pokud vrátí `null`, volání `flatMap` selže.

## Náhradní hodnota se může počítat zbytečně

`orElse(defaultTitle())` vyhodnotí argument ještě před samotným voláním orElse, i když výsledek existuje. `orElseGet(() -> defaultTitle())` dodá funkci, která se spustí až při absenci. Pro obyčejný hotový text je orElse přehledné; pro drahý výpočet nebo načítání je rozdíl podstatný.

`ifPresent` vykoná akci jen pro přítomnou hodnotu. `orElseThrow` ji vyžádá, případně vyvolá výjimku. Volání get bez ověření přítomnosti může selhat stejně jako nekontrolovaná práce s null. Nejdřív si ujasni, co má program udělat, když hodnota chybí. Podle toho vyber vhodnou metodu.

## Co do Optional nepatří

Prázdný výsledek hledání není totéž co nečitelný soubor nebo rozbitá síť. Technickou chybu neproměňuj bez vysvětlení na empty; uživatel by uvěřil, že záznam neexistuje. Pro více výsledků obvykle vrať prázdný seznam místo Optional<List<T>>. Optional je nejpřirozenější na návratu vyhledávací metody, není povinným obalem každého pole a parametru.

V procvičení odliš chybějící klíč, prázdný text, mezery a doslovné slovo null. Pro každý z těchto případů si před spuštěním napiš, jestli očekáváš nalezenou hodnotu, nebo prázdný výsledek.
