## Dvě hodnoty na jednom řádku

Na jmenovku potřebuješ jeden ze dvou popisků podle věku. Když pouze vybíráš hodnotu, můžeš místo `if / else` použít **ternární operátor (ternary operator)**:

```java
int age = 18;
String label = age >= 18 ? "dospela" : "mladsi";
```

Čti: „Je jí alespoň 18? Pak použij dospela, jinak mladsi.“ Výsledný text se uloží do `label`. Pokud bys v každé větvi potřebovala udělat několik kroků, použij běžné `if`.

## Několik konkrétních možností

Rozvrh může ukládat den jako číslo a pro výpis potřebovat jeho název. **Výraz switch (switch expression)** k jednotlivým hodnotám přiřadí výsledek:

```java
int day = 2;
String label = switch (day) {
    case 1 -> "pondeli";
    case 2 -> "utery";
    default -> "jiny den";
};
```

`default` pokryje ostatní čísla. Celý výraz vrátí text, který se uloží do `label`.

U tohoto zápisu se šipkami nepřidáváš `break`. Starší switch s dvojtečkami má jiná pravidla.

Pokud by krátký zápis vyžadoval několik vnořených otazníků, vrať se k `if / else`. Čitelnost má přednost před délkou.

## Klasický switch a propadávání

Můžeš potkat i příkaz `switch` s dvojtečkami. Do `main` vlož:

```java
int option = 2;
switch (option) {
    case 1:
        System.out.println("Nová hra");
        break;
    case 2:
        System.out.println("Nápověda");
        break;
    default:
        System.out.println("Neznámá volba");
}
```

`break` zde ukončí nejbližší switch. Bez něj může provádění pokračovat i příkazy další větve, čemuž se říká **fall-through**. Pro běžná menu je bezpečnější moderní šipková varianta, která takto nepropadává. `case` označuje konkrétní hodnotu, ne obecnou podmínku typu `age > 18`; pro rozsahy obvykle zvol `if`.

## Switch může vrátit hodnotu

Výrazový switch musí pokrýt všechny možné vstupy. Pro číslo nebo text proto obvykle potřebuje `default`; pro výčet lze uvést všechny enum konstanty. Více hodnot může sdílet větev `case 1, 2 -> "Začátek";`. Když větev potřebuje více příkazů, vrátí hodnotu pomocí `yield`:

```java
String command = "help";
String message = switch (command) {
    case "help" -> {
        String heading = "Příkazy";
        yield heading + ": help, quit";
    }
    case "quit" -> "Konec";
    default -> "Neznámý příkaz";
};
System.out.println(message); // Příkazy: help, quit
```

`yield` dodá výsledek větve switch; `return` by ukončil celou metodu. Středník za poslední `}` patří k přiřazení výrazu. Textové hodnoty se porovnávají podle obsahu. Ukázka nepřijímá `null`; chybějící vstup vyřeš před switchem.

Ternární operátor `?:` použij, když vybíráš dvě jednoduché hodnoty. Vnořené ternární řetězce bývají hůře čitelné než `if/else`. Napiš menu pro help, quit a neznámý příkaz a ověř všechny tři větve zvlášť.
