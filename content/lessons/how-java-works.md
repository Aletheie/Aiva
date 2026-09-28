## Od souboru ke spuštěnému programu

1. Píšeš do souboru `Main.java`.
2. **Překladač (compiler)** jménem `javac` zkontroluje zápis a vytvoří bytecode, obvykle v souboru `Main.class`.
3. **JVM (Java Virtual Machine)** tento bytecode vykoná. Program například vypíše pozdrav.

Když v pozdravu změníš `Ahoj` na `Dobrý den`, měníš soubor `.java`. Aby se nový text objevil ve výstupu, musí se uložená změna znovu přeložit a potom spustit. Editor nebo AIVA tyto kroky spustí za tebe. Soubor `.class` ručně neupravuj.

## Co znamená JDK

**JDK (Java Development Kit)** je sada nástrojů: obsahuje překladač i prostředí pro běh včetně JVM. Tu budeme potřebovat.

Označení **JRE** se používá pro prostředí k běhu. Samotné prostředí bez překladače pro naše cvičení nestačí.

## Kde vznikla chyba?

- **Před spuštěním:** třeba chybí středník. Oprav zápis.
- **Při běhu:** třeba program dělí celé číslo nulou. Hledej, jaké hodnoty použil.
- **Ve výsledku:** program běží, ale počítá špatně. Porovnej postup se zadáním.

JVM může bytecode interpretovat i překládat do strojového kódu za běhu pomocí **JIT**. Pro první program stačí rozlišovat překlad zdrojového kódu a jeho spuštění.

Budeme spouštět [programy se vstupem a výstupem](lesson:what-is-programming). Následující pokus ukazuje překlad i spuštění zvlášť.

## Vyzkoušej celý překlad ručně

V nové cvičné složce vytvoř `Main.java`:

```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Java běží");
    }
}
```

Otevři terminál v téže složce. Terminál přijímá příkazy pro nástroje, není to místo pro vkládání Java řádků:

```sh
javac -encoding UTF-8 --release 21 Main.java
java Main
```

`javac` přeloží zdroj. `-encoding UTF-8` určuje kódování souboru, `--release 21` verzi jazyka a standardního API. Příkaz `java Main` spustí třídu; nepíšeš zde `Main.class`. Výsledkem je řádek `Java běží`. V aktuální složce musí být přeložený soubor; u složitějších projektů se cesta nastavuje přes classpath.

## Přenositelnost a verze

Bajtkód je instrukční formát pro JVM, ne přímo kód procesoru. Stejné `.class` může běžet na různých systémech, pokud mají kompatibilní JVM a potřebné knihovny. Program ale může stále záviset na konkrétním počítači. Třeba cesta `C:\kurz` na Macu obvykle neexistuje a knihovna určená jen pro Windows na něm nepoběží. Novější JVM zpravidla spustí starší bajtkód, starší JVM ale nemusí umět bajtkód vytvořený pro novější vydání.

Java za běhu může často používané části přeložit JIT překladačem do strojového kódu. Správu paměti usnadňuje **garbage collector**, který uvolňuje paměť nedosažitelných objektů. To ale neznamená automatické uzavření otevřeného souboru; souborové prostředky budeme spravovat výslovně.

## Který krok právě zkoušíš

Odstraň středník za `println` a zkus `javac`: překlad selže. Pokud potom spustíš starý existující `Main.class`, může stále vypsat původní výsledek. Proto vždy sleduj, zda nový překlad opravdu uspěl. Vrať středník, znovu přelož a teprve potom spusť. Tak oddělíš chybu v aktuálním zdroji od běhu staré verze.

> [!OPTIONAL] Pod povrch: prohlédni si bajtkód
>
> JDK obsahuje také `javap`, nástroj pro prohlížení přeložených tříd. Po úspěšném překladu příkladu spusť v téže složce `javap -c Main`. Volba `-c` vypíše instrukce metod. `getstatic` načte statický člen, zde výstup `System.out`, `ldc` načte konstantu, například text pozdravu, a `invokevirtual` volá instanční metodu jako println. `return` ukončí metodu bez hodnoty.
>
> Čísla vlevo jsou pozice instrukcí v bajtkódu, ne řádky zdroje. Instrukce používají pracovní zásobník hodnot uvnitř rámce metody. JVM je může interpretovat nebo JIT přeložit; `javap` tedy neukazuje konečné instrukce procesoru. Přesné rozložení závisí i na překladači, proto se uč význam toku, ne konkrétní číselné offsety.
