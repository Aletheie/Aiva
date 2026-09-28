## Program se zeptá, ty odpovíš

Pokud by pozdrav obsahoval jméno přímo v kódu, musela bys program před každým dalším hostem přepsat. **Vstup (input)** dovolí jméno zadat až při spuštění. Stejný program tak jednou pozdraví Adu, podruhé Evu.

Pro čtení použijeme připravený nástroj `Scanner`:

```java
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        String name = input.nextLine();
        System.out.println("Ahoj, " + name + "!");
    }
}
```

`import` na začátku zpřístupní nástroj Scanner. Řádek s `new Scanner` zatím ber jako přípravu čtečky; `new` si vysvětlíme u objektů.

## Jeden řádek = jeden text

`nextLine()` počká na řádek a vrátí ho jako `String`. Při ručním spuštění napiš třeba `Ada` a stiskni Enter. Výstup bude `Ahoj, Ada!`.

Po spuštění může konzole zůstat prázdná a čekat na psaní. Klikni do ní, napiš jméno a stiskni Enter. Teprve potom se program dostane k výpisu pozdravu.

## Jak to funguje při kontrole

AIVA dodá vstup ze zadání automaticky. Nevypisuj proto otázku navíc, pokud ji zadání nepožaduje.

Číslo zadané přes `nextLine()` je zatím také text. Převod na číslo bude samostatný další krok.

Načtený řádek uložíme do [proměnné](lesson:variables), abychom s ním mohli dál pracovat.

## Co jednotlivé části čtečky znamenají

`Scanner` je třída ze standardní knihovny `java.util`. `new Scanner(System.in)` vytvoří objekt čtečky nad standardním vstupem programu. `input` je proměnná s odkazem na tuto čtečku. `input.nextLine()` volá její instanční metodu; každý další takový příkaz postupuje dál vstupem. `System.in` je vstup, `System.out` výstup. `import` jen zkracuje název typu, nestahuje žádný balíček.

## Dva řádky a prázdný řádek

Do `main` po vytvoření čtečky vlož:

```java
String firstName = input.nextLine();
String city = input.nextLine();
System.out.println(firstName + " žije v " + city);
```

Při vstupu Ada na prvním řádku a Brno na druhém vznikne `Ada žije v Brno`. Záměrně tu neřešíme skloňování, pouze pořadí dat. Pokud první řádek obsahuje jen Enter, první hodnota je prázdný text. `nextLine` neodstraní mezery na jeho okrajích, jen oddělovač řádku.

`hasNextLine()` zjišťuje, zda lze číst další řádek, a při interaktivním vstupu může také čekat. Když už vstup skončil, vrátí `false`. Volání `nextLine()` bez dalšího řádku by vyvolalo `NoSuchElementException`. Použití v podmínce a cyklu si vyzkoušíme později.

## Jedna čtečka, jeden zdroj

Nevytvářej několik Scannerů nad `System.in` pro každou otázku. Jejich vyrovnávací paměti by si mohly čtení komplikovat. `input.close()` zavře čtečku a zároveň její podkladový vstup; po uzavření `System.in` už z něj další část programu číst nemůže. Proto v krátkém konzolovém programu sdílíme jednu čtečku a neuzavíráme ji uprostřed zpracování.

Vyzkoušej jméno se dvěma slovy. Obě mají zůstat v jednom textu. Pozdější `next()` čte jen token oddělený bílými znaky; není náhradou za celý řádek.
