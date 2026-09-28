## Chybějící hodnota není prázdná hodnota

U jména návštěvníka rozlišuj tři situace. `null` znamená, že proměnná neodkazuje na žádný text. `""` je existující text bez jediného znaku, třeba prázdná odpověď z formuláře. `"null"` je obyčejné čtyřpísmenné slovo, které někdo mohl napsat. Na posledních dvou hodnotách zavoláš `length()` a dostaneš 0 nebo 4. Na skutečném `null` metodu zavolat nelze.

U pole objektů může existovat samotné pole, ale některé jeho prvky mohou být `null`.

`NullPointerException` často ukazuje místo, kde se problém projevil, ne místo, kde chybějící hodnota vznikla. Při ladění sleduj, odkud reference přišla a zda tam vůbec směla chybět. Plošné zachytávání této výjimky nenahrazuje pravidlo pro vstupy.

## Co zobrazit, když jméno chybí

**Smlouva metody (contract)** říká, jaké vstupy metoda přijímá a co vrací. Pro přezdívku zvolme pravidlo: chybějící nebo prázdná přezdívka se zobrazí jako Host; jinak se odstraní okrajové mezery. To je rozhodnutí naší aplikace. U čísla bankovního účtu by vymyšlená náhradní hodnota byla špatně.

Celý soubor `Main.java`:

```java
public class Main {
    static String displayName(String name) {
        if (name == null || name.isBlank()) {
            return "Host";
        }
        return name.strip();
    }

    public static void main(String[] args) {
        String[] names = {null, "", "   ", "  Ada  ", "null"};
        for (String name : names) {
            System.out.println(displayName(name));
        }
    }
}
```

Výsledkem jsou řádky Host, Host, Host, Ada a null. `isBlank()` pozná prázdný text i text složený z bílých znaků. `strip()` vrátí text bez bílých znaků na okrajích; nemění původní objekt ani mezery uvnitř. Operátor `||` druhou část nevyhodnotí, když první platí. Otočení podmínek by proto program rozbilo právě pro `null`.

## Předčasný návrat zpřehlední běžný případ

Stejnou metodu lze rozepsat na dvě úvodní kontroly: `if (name == null) return "Host";` a potom `if (name.isBlank()) return "Host";`. Takovému návratu před hlavní činností se říká **guard clause**. Nemusíš každou další operaci balit do dalšího `else`. Oba zápisy mají pro stejné vstupy vracet stejné výsledky.

Pro konkrétní příkaz je bezpečné `"konec".equals(command)`: objekt vlevo určitě existuje. Opačné volání `command.equals("konec")` je bezpečné jen tehdy, když víš, že command není null. Podmínka `command != null && command.length() > 0` využívá obdobně zkrácené vyhodnocení `&&`.

## Nepřidávej náhradní hodnoty naslepo

Návrat prázdného seznamu může znamenat žádné výsledky. Neměl by současně maskovat neúspěšné načtení databáze. U povinných vstupů později poznáš odmítnutí pomocí [výjimky](lesson:exceptions-overview); pro očekávané nenalezení výsledku existuje dobrovolná lekce [Optional](lesson:optional-values).

Ověř alespoň skutečné null, prázdný text, mezery, běžné jméno a doslovný text null. Ke každému případu napiš očekávané chování před spuštěním. Uvidíš tak, jestli oprava pro jeden případ omylem nezměnila chování ostatních.
