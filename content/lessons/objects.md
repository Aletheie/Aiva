## Popis a konkrétní věc

Představ si knižní katalog. Všechny jeho kartičky mají stejná pole, třeba název a autora, ale každá popisuje jinou knihu. **Třída (class)** je společný popis takového záznamu. **Objekt (object)** je jeden konkrétní záznam vytvořený podle něj.

Naší třídě `Book` zatím stačí údaj `title`. Jeden objekt bude popisovat Dunu, druhý Malého prince.

## Vytvoř dva objekty

Do souboru `Book.java` patří:

```java
public class Book {
    String title;
}
```

Do `main` ve stejném projektu:

```java
Book first = new Book();
first.title = "Duna";
Book second = new Book();
second.title = "Malý princ";
System.out.println(first.title); // Duna
```

`new` vytvoří nový objekt. Tečkou přistupuješ k jeho údaji. `title` je **pole objektu (field)**; není to totéž co pole několika hodnot neboli array.

## Každý objekt má vlastní stav

Změna `second.title` nezmění `first.title`, protože jsme vytvořili dva různé objekty.

Proměnná typu `Book` drží **odkaz (reference)** na objekt. Hodnota `null` znamená, že na žádný objekt neodkazuje. Z `null` nelze číst `title`.

Teď údaje nastavujeme přímo. V další lekci je nastavíme při vytvoření a přidáme metody.

Objekt spojí hodnoty podobné [proměnným](lesson:variables) a operace podobné [metodám](lesson:methods).

## Stav a chování v jednom příkladu

U dveří do dvou sálů můžeš mít dva samostatné čítače návštěvníků. Jejich **stav** je aktuální počet lidí; jejich **chování** je například přičtení dalšího příchodu. V kódu stav ukládáme do polí a chování zapisujeme do metod. Tento celý `Main.java` obsahuje pomocnou třídu `Counter` i vstupní třídu `Main`:

```java
class Counter {
    int value;

    void increment() {
        value++;
    }

    int current() {
        return value;
    }
}

public class Main {
    public static void main(String[] args) {
        Counter first = new Counter();
        Counter second = new Counter();
        first.increment();
        first.increment();
        second.increment();
        System.out.println(first.current());  // 2
        System.out.println(second.current()); // 1
    }
}
```

Oba objekty mají pole stejného názvu, ale jinou hodnotu. `increment()` zvýší pole objektu, přes který je metoda volaná. `current()` vrací jeho stav. Slovo **instance** znamená konkrétní objekt určité třídy. Třída není složka se všemi objekty; je to jejich typ a popis.

V ukázce nemají členy modifikátor přístupu, takže jsou dostupné v rámci balíčku. Není to automaticky public. Brzy pole skryjeme pomocí private, aby je okolí nemohlo měnit bez pravidel.

## Dvě reference na jeden objekt

Po `Counter alias = first;` nevznikne třetí čítač. `alias.increment()` změní stejný objekt jako `first.increment()`, a první čítač pak ukáže 3. Nakresli si obě proměnné jako dvě šipky do jedné krabičky a `second` jako šipku do jiné.

`Counter missing = null;` znamená, že reference nemá cíl. `missing.current()` vyvolá `NullPointerException`; null není objekt s nulovými poli. U metody nebo konstruktoru vždy popiš, zda přijímá i `null` a co v takovém případě udělá.

## Údaje a operace, které patří k sobě

U knihy můžeš později evidovat také dostupnost a přidat metodu pro vypůjčení. Metoda změní dostupnost právě té knihy, na které ji zavoláš. Podobně `first.increment()` připočítá návštěvníka jen u prvního sálu. Související údaje a operace tak najdeš pohromadě.

Přidej čítači `reset()` nastavující nulu a zavolej ho pouze na `first`. Druhý čítač musí zůstat na 1. Tím ověříš rozdíl mezi společnou definicí třídy a nezávislým stavem instancí.

> [!OPTIONAL] Pod povrch: heap, reference a garbage collector
>
> JVM modeluje objekty a pole v oblasti **heap**, sdíleném prostoru spravovaném běhovým prostředím. Reference se mohou nacházet v lokálních proměnných, polích dalších objektů i statických členech. Reference není adresa, se kterou bys v běžné Javě mohla aritmeticky posouvat ukazatel.
>
> Garbage collector uvolňuje objekty, které už nejsou dosažitelné z živé části programu. Samotný konec bloku tedy neznamená konec objektu, pokud na něj někdo dál odkazuje. Dva objekty odkazující jen na sebe mohou být oba nedosažitelné a uvolnitelné.
>
> Čas úklidu není zaručen. Soubory ani jiné systémové prostředky proto nesvěřujeme čekání na GC; používáme close a try-with-resources. Model heap/stack pomáhá vysvětlit životnost, ale moderní JVM smí fyzické alokace optimalizovat, pokud zachová chování programu.
