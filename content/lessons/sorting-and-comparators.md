## Přirozené pořadí nestačí na každou situaci

Na výsledkové listině chceš nejprve nejvyšší počet bodů. Ada a Zoe jich ale mají shodně dvanáct — kdo bude první? Doplníme druhé pravidlo: při shodě bodů rozhodne jméno vzestupně. **Comparator** popisuje takové porovnání dvojice hodnot mimo samotný datový typ. **Comparable** naopak určuje přirozené pořadí uvnitř typu. Stejné výsledky tak můžeš jednou seřadit podle bodů a podruhé podle jména.

Celý `Main.java` používá počet bodů sestupně a jméno vzestupně:

```java
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Main {
    record Score(String name, int points) {}

    public static void main(String[] args) {
        List<Score> original = List.of(
                new Score("Eva", 8), new Score("Zoe", 12), new Score("Ada", 12));
        List<Score> sorted = new ArrayList<>(original);
        sorted.sort(Comparator.comparingInt(Score::points).reversed()
                .thenComparing(Score::name));
        for (Score score : sorted) System.out.println(score.name());
    }
}
```

Výstup je Ada, Zoe, Eva. `comparingInt` vytáhne číselný klíč pomocí reference na metodu. `reversed()` převrátí právě toto pravidlo. `thenComparing` se použije jen tehdy, když první porovnání vrátí shodu. Pokud přesuneš reversed až na konec, obrátíš celé složené pořadí včetně jmen.

## Záporné, nulové, kladné

Metoda compare vrací záporné číslo, když první hodnota patří před druhou, nulu pro shodu pořadí a kladné pro opačný směr. Nevyžaduje přesně -1 a 1. Číselné hodnoty porovnávej pomocí Integer.compare nebo comparingInt. Odčítání `a - b` může přetéct a obrátit výsledek pro velmi vzdálené hodnoty.

Pravidlo musí být konzistentní a tranzitivní: jestli A patří před B a B před C, A musí patřit před C. Náhodný výsledek z compare nebo pravidlo měnící se během řazení tyto požadavky porušuje. Komparátor nemá při porovnání upravovat porovnávané objekty.

## Stejný počet stran neznamená stejnou knihu

Dvě knihy mohou mít stejný počet stran, ale nejsou tím stejnou knihou. Nula z porovnání podle délky neznamená automaticky equals. U TreeSet nebo TreeMap má shoda komparátoru vliv na jedinečnost prvků či klíčů; nevhodné pravidlo tam může sloučit položky, které jsi chtěla zachovat.

List.sort je stabilní: položky, které komparátor považuje za shodné, zachovají vzájemné původní pořadí. Výslovný druhý klíč ale dává čtenáři srozumitelné pravidlo nezávislé na pořadí importu.

## Původní pořadí zachová kopie

List.sort mění příjemce. Chceš-li zachovat původní seznam, vytvoř nejprve kopii jako v programu. Stream.sorted sestaví jiný průchod a původní seznam nemění. Pro data obsahující null by bylo potřeba další pravidlo, například nullsLast; naše úloha nulové prvky nepřipouští.

Přirozené řazení String není české jazykové řazení. To se řeší Collator s vybraným jazykem. V této lekci jsou vstupy záměrně ASCII, aby byly očekávané výsledky přesné a nezávislé na nastavení počítače. Ověř zejména shodu prvního klíče a zachování původního seznamu.
