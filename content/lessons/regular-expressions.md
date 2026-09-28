## Jednoduché pravidlo pro podobné texty

Zásilky mají kódy jako `AB-007`: dvě velká písmena, pomlčka a tři číslice. Nechceme porovnávat s jedním konkrétním kódem, ale ověřit tento společný tvar. **Regulární výraz (regular expression)**, zkráceně regex, takové pravidlo popíše. Pro porovnání jednoho slova stačí `equals`; pro složité formáty jako JSON nebo XML použij jejich parser.

Celý soubor `Main.java` ověří místní kód zásilky:

```java
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Main {
    public static void main(String[] args) {
        Pattern rule = Pattern.compile("([A-Z]{2})-([0-9]{3})");
        Matcher match = rule.matcher("AB-007");
        if (match.matches()) {
            System.out.println(match.group(1)); // AB
            System.out.println(match.group(2)); // 007
        } else {
            System.out.println("Neplatný kód");
        }
    }
}
```

Pattern je připravený vzor, Matcher ho spojuje s konkrétním vstupem a nese stav hledání. Jeden Pattern můžeš použít pro více samostatných matcherů. Group čti až po úspěšném hledání nebo ověření, jinak není žádná aktuální shoda.

## Malý slovník vzorů

`[A-Z]` připouští jedno velké ASCII písmeno. `[0-9]` jednu číslici z tohoto rozsahu. `{3}` opakuje předchozí část právě třikrát, `+` jednou nebo vícekrát, `*` i nulakrát, `?` nanejvýš jednou. Kulaté závorky zachytí skupinu, kterou potom přečteš podle čísla od jedničky. Skupina nula je celá shoda.

Tečka znamená libovolný znak s výjimkami podle režimu, nikoli automaticky doslovnou tečku. Pro doslovnou tečku potřebuje regex zápis `\.`; uvnitř Java řetězce napíšeš `"\\."`. Jednu vrstvu escapování čte Java a druhou regex. V obyčejném textovém poli nebo dokumentaci regexu tedy počet lomítek může vypadat jinak než ve zdrojovém kódu.

## Celý kód, nebo kód uvnitř věty

`matches()` ověřuje celý vstup: `AB-007` projde, ale věta `Zásilka AB-007 dorazila` ne. `find()` v téže větě naopak najde úsek `AB-007`. Pro kontrolu samostatného štítku tedy použij `matches()`. Když chceš z odstavce vytáhnout všechny kódy, opakuj `while (match.find())`.

Metoda `String.matches(regex)` je krátká cesta pro jednorázové ověření. Opakovaně používaný vzor připrav jednou přes Pattern.compile. Chybný vzor vyvolá PatternSyntaxException; ta znamená problém pravidla, nikoli automaticky neplatný vstupní text.

## Data nejsou automaticky vzor

Chceš-li do vzoru vložit doslovný text dodaný uživatelem, použij Pattern.quote. Jinak by třeba tečka nebo závorky změnily význam. Náhradní text u regexového nahrazování má zase vlastní pravidla pro dolar a zpětné lomítko; pro něj slouží Matcher.quoteReplacement.

Zůstaň u malých, srozumitelných vzorů a omez délku vstupu. Některé kombinace vnořených opakování mohou při téměř správném vstupu vyžadovat velmi mnoho práce. Delší regex proto není automaticky lepší validátor. V této lekci je pravidlo záměrně krátké a pevně dlouhé.

Ověř `AB-007`, zkrácené `AB-07`, malá písmena v `ab-007`, text před kódem i za ním a prázdný řádek. Tato sada rychle odhalí častou záměnu find za matches.
