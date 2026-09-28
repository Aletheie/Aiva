## Co se stane, když místo věku přijde „ahoj“

Program čeká věk, ale dostane text `"ahoj"`. `Integer.parseInt` z něj číslo nevytvoří a vyvolá **výjimku (exception)**: objekt popisující selhání. Běžné provádění se přeruší a Java hledá odpovídající `catch`, kde můžeš například požádat o nový vstup. Převod tedy nevrátí nulu, se kterou by program potichu počítal dál. Navazuješ na [čtení čísel](lesson:console-numbers).

## Zachycení konkrétní chyby

Celý program v `Main.java`:

```java
public class Main {
    static int readAge(String text) {
        int age = Integer.parseInt(text);
        if (age < 0) {
            throw new IllegalArgumentException("Věk nesmí být záporný");
        }
        return age;
    }

    public static void main(String[] args) {
        String[] inputs = {"18", "ahoj", "-2"};
        for (String input : inputs) {
            try {
                System.out.println(readAge(input));
            } catch (NumberFormatException error) {
                System.out.println("Zadej celé číslo");
            } catch (IllegalArgumentException error) {
                System.out.println(error.getMessage());
            } finally {
                System.out.println("Pokus dokončen");
            }
        }
    }
}
```

Pro první vstup se vypíše `18` a `Pokus dokončen`. Pro druhý `Zadej celé číslo` a stejná závěrečná zpráva. Pro třetí `Věk nesmí být záporný` a závěrečná zpráva.

`try` obaluje operaci, která může selhat. `catch (Typ jméno)` zpracuje odpovídající objekt; `getMessage()` vrátí jeho popis, obecně může být i `null`. `finally` se při běžném opuštění bloku provede bez ohledu na úspěch, zachycení nebo `return`. Není zárukou při násilném ukončení procesu či pádu JVM. Nepiš v něm `return`, který by zakryl původní výsledek nebo výjimku.

## Hierarchie rozhoduje o pořadí catch

Základní vztahy jsou:

```text
Throwable
  Error
  Exception
    IOException
    RuntimeException
      IllegalArgumentException
        NumberFormatException
      NullPointerException
```

`NumberFormatException` je potomkem `IllegalArgumentException`, proto ji zachytáváme první. Obrácené pořadí by udělalo konkrétnější `catch` nedosažitelným a překladač by ho odmítl. `Error` zpravidla označuje zásadní problémy prostředí; běžná aplikace ho rutinně nezachytává.

**Checked výjimky** jsou potomci `Exception` kromě `RuntimeException` a jejích potomků. Překladač vyžaduje jejich zachycení nebo uvedení v `throws`, například u `IOException`. **Unchecked výjimky** zahrnují `RuntimeException` a `Error` s potomky; překladač zachycení nevyžaduje. Neznamená to, že jsou automaticky méně závažné nebo že se nemají opravovat.

## Throw chybu vyvolá, throws ji uvádí v hlavičce

`throw new IllegalArgumentException("...")` vyvolá konkrétní výjimku. Deklarace `static String load() throws IOException` říká, že metoda může kontrolovanou chybu předat volajícímu. Sama ji neopravuje. Řetězu předání směrem k volajícím říkáme **propagace**.

Vlastní kontrolovanou výjimku lze definovat jako `class InvalidDataException extends Exception` s konstruktorem `InvalidDataException(String message) { super(message); }`. `super(message)` předává zprávu předkovi. Hodí se například tehdy, když má volající rozlišit neplatný obsah souboru od chyby při jeho otevření. Pokud tuto odlišnou reakci nepotřebuješ, může stačit existující typ výjimky.

## Automatické uzavření prostředků

Souborový čtenář drží systémový prostředek. `try-with-resources` zapíše jeho vytvoření do kulatých závorek za `try` a při opuštění bloku zavolá `close()`. Prostředek musí implementovat `AutoCloseable`. Konkrétní použití `Files.newBufferedReader(...)` a metody `readLine()` si hned vyzkoušíš v [souborech](lesson:files-overview).

Více prostředků se uzavírá v opačném pořadí vytvoření. Když selže tělo i uzavření, původní chyba zůstává hlavní a chyba uzavření je potlačená, dostupná přes `getSuppressed()`, které vrací pole dalších výjimek. Pro začátek je klíčové nezapomenout prostředek uzavřít ani při selhání.

## Kde chybu řešit

Zachytávej tam, kde umíš reagovat: konzole může vyžádat opravu vstupu, ukládání může oznámit problém a zachovat data v paměti. Prázdný `catch` ani nahrazení chyby hodnotou nula nejsou oprava; ztratily by informaci o selhání. `catch (Exception e)` kolem celého programu může ukrýt programátorskou chybu, kterou bylo potřeba odladit.

Přidej vstup `0` a příliš velké celé číslo. Nulový věk v této ukázce přijímáme, číslo mimo rozsah `int` skončí v `NumberFormatException`. `"ahoj"` tedy není zápis čísla, zatímco `"-2"` číslo je, ale nevyhovuje našemu pravidlu pro věk. Proto dostávají různé zprávy.

> [!OPTIONAL] Pod povrch: odvíjení zásobníku
>
> Když metoda vyvolá výjimku a nemá odpovídající catch, běžný návrat se neprovede. Hledání obsluhy pokračuje do rámce volajícího. Při tomto **odvíjení zásobníku (stack unwinding)** se provádějí příslušné finally bloky a uzavírání prostředků.
>
> Výpis stack trace zachycuje cestu volání důležitou pro diagnostiku. Vytváření výjimek může být dražší než běžná větev; nepoužívej je jako náhradu každého očekávaného boolean výsledku. Neplatný zápis čísla zpracuj jako chybu vstupu. Hledání bez shody ale může být běžný výsledek.
