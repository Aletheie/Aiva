## Balíček je součást názvu třídy

V knihovně eviduješ knihu kvůli výpůjčce, v obchodě kvůli prodeji. Obě části programu mohou mít třídu `Book`, přestože každá potřebuje jiné údaje. **Balíček (package)** rozliší třídy se stejným názvem: `library.Book` a `shop.Book` jsou dva různé typy. Názvy balíčků se běžně píšou malými písmeny a odpovídají složkám pod kořenem zdrojových souborů.

Kořenem zdrojů zde je `src/main/java`. Není součástí jména balíčku. Soubor `src/main/java/library/Book.java` tedy nezačíná package src.main.java.library. Začíná následujícím obsahem:

```java
package library;

public class Book {
    public String describe(String title) {
        return "Kniha: " + title;
    }
}
```

Druhý soubor `src/main/java/Main.java`:

```java
import library.Book;

public class Main {
    public static void main(String[] args) {
        Book book = new Book();
        System.out.println(book.describe("Maly princ"));
    }
}
```

`package` píšeme před importy, importy před třídou. Veřejná třída Book má stejné jméno jako soubor Book.java, včetně velikosti písmen. Na některých discích se chyba v písmenech dlouho schovává; v jiném prostředí pak překlad selže.

## Import není stažení knihovny

`import library.Book` dovoluje psát krátce Book. Bez něj můžeš použít `library.Book book = new library.Book();`. Import sám nevytvoří třídu, nenainstaluje závislost a nezpřístupní soukromou metodu. Třída i volaná metoda v našem příkladu jsou public, protože je používáme přes hranici balíčku.

Typy ze stejného balíčku se navzájem importovat nemusí. `String`, `System` a další typy z `java.lang` jsou dostupné automaticky. Zápis `import java.util.*` zahrne typy přímo z java.util, nikoli jeho podbalíčky. Dva různé typy stejného krátkého názvu nejde současně rozlišit dvěma obyčejnými importy; jeden napiš úplným jménem.

## Přelož a spusť celý malý projekt

Z adresáře nad `src` spusť:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java src/main/java/library/Book.java
java -cp out Main
```

Překladač vytvoří výstupní adresář out a uvnitř i library/Book.class. `-d` určuje kořen výstupu, `-cp` neboli classpath říká JVM, kde hledat třídy. Výstup bude Kniha: Maly princ. Nepředávej Javě cestu k souboru `.class` místo jména třídy.

Pokud i Main přesuneš například do balíčku app, přidej mu package app, ulož ho do odpovídající složky a spouštěj `java -cp out app.Main`. Při chybě ClassNotFoundException nejprve ověř kořen classpath a úplné jméno, místo náhodného přesouvání souborů.

## Které třídy patří k sobě

Do `library` mohou později patřit také čtenáři a výpůjčky. `Main` pak načte požadavek, zavolá potřebnou metodu a vypíše odpověď. Samostatný balíček má smysl pro související část programu; nepotřebuješ nový pro každou metodu. Rozliš také Java balíček od výsledného archivu JAR, který později obsahuje přeložený projekt. Viditelnost a ochranu stavu rozvine [zapouzdření](lesson:encapsulation-overview), automatické sestavení [Maven](lesson:maven-overview).
