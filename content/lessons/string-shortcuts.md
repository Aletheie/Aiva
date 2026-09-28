## Je v textu něco kromě mezer?

Návštěvnice do políčka pro jméno napsala jen dvě mezery. Text má délku dva, ale jméno se z něj nedozvíš. Právě proto se hodí rozlišovat `isEmpty()` a `isBlank()`:

```java
System.out.println("".isEmpty());   // true
System.out.println("  ".isEmpty()); // false
System.out.println("  ".isBlank()); // true
```

`isEmpty()` ověřuje nulovou délku. `isBlank()` přijme i text tvořený jen bílými znaky, například mezerami a tabulátory. Hodí se pro kontrolu nevyplněného jména.

## Očisti příkaz a porovnej ho

```java
String command = " KONEC ";
boolean finished = command.strip().equalsIgnoreCase("konec");
System.out.println(finished); // true
```

`strip()` odstraní krajní bílé znaky podle pravidel Javy. Je podobné známému `trim()`, ale umí i další bílé znaky. `equalsIgnoreCase(...)` porovná obsah bez rozlišení velkých a malých písmen; pro jednoduchý příkaz je to pohodlné.

## Pořadí čti zleva doprava

Nejdřív vznikne očištěný text, potom se porovná. Původní `command` zůstává beze změny.

Pokud ti řádek připadá dlouhý, ulož očištěný text do pomocné proměnné. Tyto metody volej na skutečném textu, ne na `null`.

## Pět podob příkazu konec

Následující program nepotřebuje konzolový vstup, proto lze stejné případy opakovat:

```java
public class Main {
    static boolean isQuit(String command) {
        return command != null && command.strip().equalsIgnoreCase("konec");
    }

    public static void main(String[] args) {
        String[] commands = {"konec", " KONEC ", "pokračuj", "   ", null};
        for (String command : commands) {
            System.out.println(isQuit(command));
        }
    }
}
```

Výstup je true, true, false, false, false na pěti řádcích. `command != null` předchází volání metod; zkrácené vyhodnocení `&&` druhou část pro null přeskočí. `strip` vrátí očištěný text, `equalsIgnoreCase` porovná příkaz. Návratová hodnota je boolean, nikoli text s napsaným slovem true.

## Stejný postup rozepsaný po krocích

V metodě lze místo jednoho výrazu nejdřív použít `if (command == null) { return false; }`, pak `String clean = command.strip();` a nakonec `return clean.equalsIgnoreCase("konec");`. Výsledky jsou stejné. Kratší varianta je vhodná, pokud je pořadí kontrol jasné; delší se může lépe krokovat.

U lidských jmen a hesel neprováděj automaticky stejnou normalizaci jako u technických příkazů. V hesle mohou mezery i velikost písmen tvořit skutečný obsah. `equalsIgnoreCase` také není obecný nástroj pro jazykové řazení jmen.

Zkus příkaz s tabulátorem na okraji a s mezerou uprostřed `ko nec`. První lze očistit, druhý je jiný příkaz a musí zůstat false. V našem programu tolerujeme mezery na okrajích a rozdílnou velikost písmen. Mezery uvnitř slova neopravujeme, protože by to měnilo samotný příkaz.
