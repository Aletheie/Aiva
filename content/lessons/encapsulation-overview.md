## Poslední místo v sále

Na promítání zbývá jeden lístek. První rezervace uspěje, druhá má dostat odpověď „vyprodáno“. Kdyby libovolná část programu mohla přepsat počet míst, snadno by vzniklo -1. **Zapouzdření (encapsulation)** umožní údaj skrýt a měnit ho jen přes metody, které hlídají pravidla. Navazuješ tím na [konstruktory](lesson:constructors), které nastavují počáteční stav.

## Objekt si hlídá své pravidlo

Čítač dostupných míst nesmí klesnout pod nulu. Takovému pravidlu, které musí platit po každé veřejné operaci, říkáme **invariant**. Následující celý program ulož do `Main.java`:

```java
class Seats {
    private int available;

    public Seats(int available) {
        if (available < 0) {
            throw new IllegalArgumentException("Záporný počet míst");
        }
        this.available = available;
    }

    public int getAvailable() {
        return available;
    }

    public boolean reserve() {
        if (available == 0) {
            return false;
        }
        available--;
        return true;
    }
}

public class Main {
    public static void main(String[] args) {
        Seats seats = new Seats(1);
        System.out.println(seats.reserve());      // true
        System.out.println(seats.reserve());      // false
        System.out.println(seats.getAvailable()); // 0
    }
}
```

`private` dovoluje přístup k poli jen uvnitř jeho třídy. `public` zpřístupňuje konstruktor a metody volajícímu. `this.available` označuje pole objektu, samotné `available` v konstruktoru parametr. `getAvailable()` je **getter**: pouze vrací aktuální stav. `reserve()` je pojmenovaná operace; sníží stav jen tehdy, když existuje volné místo. `--` odečte jedničku.

`throw` ukončí běžný průběh a vyvolá výjimku, zde `IllegalArgumentException` pro nepřípustný argument. `new` vytváří objekt výjimky s vysvětlující zprávou. Pokud nikdo výjimku nezachytí, tento pokus o vytvoření objektu selže a program skončí chybou. V [lekci výjimek](lesson:exceptions-overview) se naučíš výjimku zachytit pomocí `catch` a rozhodnout, jak má program pokračovat. Vyprodání zde není výjimka: je běžný výsledek `false`.

## Setter není povinnost

**Setter** je metoda měnící pole, například `setName(String name)`. Dává smysl, pokud změna názvu patří k chování objektu a metoda ověří vstup. Veřejný `setAvailable(-20)` by rezervace obešel. Raději nabídni operace odpovídající zadání, například rezervaci nebo vrácení místa.

| Přístup | Kdo smí člen použít |
|---|---|
| `private` | Kód uvnitř vlastní třídy |
| bez modifikátoru | Třídy ve stejném balíčku, tedy package-private |
| `protected` | Stejný balíček a potomci; mimo balíček platí omezení přístupu přes referenci |
| `public` | Volající, pro které je dostupná také samotná třída |

**Balíček (package)** je pojmenovaná skupina tříd, například `cz.kurz.model`; podrobnosti a adresářovou strukturu probereme v [návrhu projektu](lesson:structure-overview). Pro začátek používej soukromá pole a malé veřejné rozhraní metod.

## Neměnnost a record

**Neměnný objekt (immutable object)** po vytvoření nemění svůj pozorovatelný stav. `final` zakazuje znovu přiřadit dané pole, ale samo nezmrazí objekt, na který pole odkazuje. `final` seznam tedy může stále obsahovat měnitelné prvky.

Pro jednoduchá data můžeš v samostatném souboru `Contact.java` napsat:

```java
public record Contact(String name, String email) {
    public Contact {
        if (name == null || name.isBlank()) {
            throw new IllegalArgumentException("Jméno chybí");
        }
    }
}
```

`record` vytvoří konstruktor, přístupové metody `name()` a `email()`, rovnost, hash i textový popis. Blok `public Contact { ... }` je **kompaktní konstruktor**: ověřuje parametry před jejich automatickým uložením. `isBlank()` vrací `true` pro prázdný text nebo samé bílé znaky; díky `||` se při `null` vůbec nevolá. `new Contact("Ada", "ada@example.test").name()` vrátí `Ada`. Record je neměnný jen mělce: referencovaná kolekce by mohla zůstat měnitelná. Zde jsou oba údaje neměnné texty.

## Zkus rezervovat více míst, než zbývá

Proveď rezervaci třikrát ze dvou míst. Očekávej `true`, `true`, `false` a stav `0`. Pak zkus vytvořit `Seats(-1)`. Vysvětli, proč jde o chybu vstupu, zatímco vyprodaná kapacita je očekávaný stav.
