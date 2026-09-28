## Tentýž objekt a stejná hodnota

Enid má kód vstupenky A7 v telefonu i na vytištěném potvrzení. Jsou to dvě kopie téhož kódu, které mají znamenat stejnou vstupenku. Podobně mohou dva různé objekty `TicketCode` obsahovat hodnotu `"A7"`. `==` zjistí, zda jde o jeden a tentýž objekt. Metodou `equals` naopak určíme, kdy mají objekty stejnou hodnotu. Bez jejího přepsání běžná třída zdědí z `Object` porovnání totožnosti.

Každá třída v Javě přímo nebo nepřímo dědí z `Object`. Odtud získává mimo jiné `equals(Object)`, `hashCode()` a `toString()`. [Přepsáním](lesson:inheritance-overview) můžeme určit, že pro náš typ rozhoduje právě text kódu.

## Rovnost podle kódu

Celý příklad v `Main.java`:

```java
import java.util.Objects;

final class TicketCode {
    private final String value;

    public TicketCode(String value) {
        this.value = Objects.requireNonNull(value, "Kód chybí");
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof TicketCode code)) {
            return false;
        }
        return value.equals(code.value);
    }

    @Override
    public int hashCode() {
        return value.hashCode();
    }

    @Override
    public String toString() {
        return "TicketCode[" + value + "]";
    }
}

public class Main {
    public static void main(String[] args) {
        TicketCode first = new TicketCode("A7");
        TicketCode second = new TicketCode("A7");
        System.out.println(first == second);      // false
        System.out.println(first.equals(second)); // true
        System.out.println(first);                // TicketCode[A7]
    }
}
```

`Objects.requireNonNull(value, zpráva)` vrátí předanou nenulovou referenci, nebo vyvolá `NullPointerException`. Díky tomu lze uvnitř bezpečně volat `value.equals(...)`. `instanceof` ověří typ; `!` výsledek neguje. Při jiném typu či `null` vracíme `false`. Po této kontrole máme proměnnou `code` pro porovnání obsahu. Privátní pole jiného objektu téže třídy lze uvnitř této třídy číst.

`toString()` vrací textovou reprezentaci. `println(first)` ji zavolá při převodu objektu na text. Tento popis pomáhá ladění; neber ho jako stabilní formát pro ukládání dat. `hashCode()` vrací číslo, podle kterého hashovací kolekce vybere skupinu pro hledání. Připomíná to rozdělení kartotéky do přihrádek: nejprve najdeš přihrádku a teprve v ní porovnáš konkrétní kódy. Dva kódy ve stejné přihrádce ještě nemusejí být stejné.

## Pravidla pro equals a hashCode

Rovnost má být reflexivní (`a.equals(a)`), symetrická (a=b znamená b=a), tranzitivní (a=b a b=c znamená a=c) a konzistentní, dokud se relevantní stav nezmění. Nenulový objekt není roven `null`.

Platí zásadní pravidlo: **objekty rovné podle equals musí mít stejný hashCode**. Opačný směr neplatí; různé objekty mohou mít stejný hash, tedy kolizi. Proto při přepisování `equals` přepisujeme i `hashCode` nad stejnými údaji. U více polí lze použít `Objects.hash(code, category)`: vrátí společný hash z argumentů.

## Proč na tom záleží u kolekcí

[HashSet a HashMap](lesson:collections-overview) nejprve využijí hash a následně rovnost. Kdybys změnila kód objektu po vložení jako klíče do mapy, mohl by zůstat ve skupině pro starý hash a vyhledání selhat. Proto jsme použili `final` třídu a neměnný text v `final` poli. Dědičnost by navíc mohla rovnost zkomplikovat odlišnými pravidly potomků.

Pro čistá data je často vhodný `record TicketCode(String value) {}`: vygeneruje rovnost, hash a popis podle svých komponent. Případnou validaci ale musíš doplnit sama; zkrácená varianta výše například dovoluje `null`.

## Kontrola na konkrétních hodnotách

Ověř dvojici A7/A7, A7/B8, porovnání s `null` a porovnání s textem `"A7"`. Očekávej postupně `true`, `false`, `false`, `false`. U první dvojice ověř shodné hashe, ale nesnaž se z různých hodnot dokazovat, že jejich hashe musí být odlišné.
