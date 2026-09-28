## První Main.java

V souboru `Main.java` může být:

```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Ahoj, Javo!");
    }
}
```

`Main` je název třídy. `main` je místo, kde tento program začne. Tuto kostru programu zatím můžeš opsat. Jednotlivé části si postupně vysvětlíme.

**Konzole (console)** je okno s textovým výstupem. `System.out.println(...)` do ní vypíše hodnotu a přejde na další řádek.

## Změň jednu věc

Z pozdravu můžeš udělat úvod do textové hry: na první řádek dej název místnosti a na druhý popis dveří. Každý řádek vypiš vlastním `println`. Soubor ulož a spusť; program bude věty vypisovat ve stejném pořadí, v jakém jsou v `main`.

Text patří do dvojitých uvozovek. Příkaz končí středníkem `;`. Složené závorky `{ }` ohraničují blok.

## Uvozovky uvnitř textu

Pokud chceš uvozovku také vypsat, napiš před ni zpětné lomítko:

```java
System.out.println("Rekla: \"Ahoj\"");
```

Výstup bude `Rekla: "Ahoj"`. Zápisu `\"` říkáme **escape sekvence**.

V kontrolovaných úlohách dodrž přesný požadovaný text. Pozdrav navíc by změnil výsledek kontroly.

Pokud se program nespustí, vrať se nejdřív k [nastavení JDK a editoru](lesson:jdk-and-ide).

## Co znamenají části programu

`public class Main` definuje veřejnou třídu jménem Main. Soubor veřejné třídy musí mít shodné jméno `Main.java`. Třída zatím slouží jako obal programu; později z tříd budeme vytvářet objekty.

`public static void main(String[] args)` je vstupní metoda této podoby programu. `public` ji zpřístupňuje, `static` dovoluje spuštění bez instance třídy a `void` říká, že nevrací výsledek volajícímu. `String[] args` je parametr, pole textových argumentů z příkazové řádky. Při spuštění `java Main Ada` by obsahovalo text Ada; v prvních programech ho nečteme. Podrobné použití přijde u [metod](lesson:methods), [polí](lesson:arrays) a [static](lesson:static-overview).

V `System.out.println("Ahoj")` je `System` standardní třída dostupná bez importu, `out` standardní textový výstup a `println` jeho metoda. Tečka vybírá pojmenovanou část, kulaté závorky předávají argument. Textový **literál** je hodnota napsaná přímo do kódu, zde `"Ahoj"`.

## print, println a escape sekvence

Do těla `main` postupně vlož:

```java
System.out.print("A");
System.out.print("B");
System.out.println("C");
System.out.println("D\nE");
System.out.println("C:\\kurz");
```

Výstup má řádky `ABC`, `D`, `E` a `C:\kurz`. `print` nepřidává konec řádku, `println` ho přidá. `\n` je nový řádek uvnitř textu, `\t` tabulátor a `\\` jedno zpětné lomítko. Uvozovky ohraničující literál se samy nevypisují.

`// komentář` trvá do konce řádku, `/* komentář */` může překročit více řádků. Komentář slouží čtenáři kódu. Při spuštění ho Java přeskočí. Velká písmena mají význam: `Main`, `main` a `MAIN` jsou různá jména.

Zkus napsat dvouřádkovou vizitku a nejprve předpověz počet řádků. Potom úmyslně smaž jednu uvozovku, přečti hlášení a oprav ho. Naučíš se rozpoznat chybu syntaxe dřív, než přidáme výpočty.
