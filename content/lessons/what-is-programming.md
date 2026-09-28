## Co bude program dělat

Nemusíš znát žádný programovací jazyk. Budeme číst malé ukázky, měnit je a sledovat, co se stane. Stačí jedna lekce najednou.

**Program** je postup zapsaný tak, aby ho počítač mohl provést. Tomuto zápisu říkáme **zdrojový kód (source code)**.

## Vstup → postup → výstup

Čtyři kamarádky se dělí o účet 480 Kč:

1. Známe částku 480 a počet lidí 4. To je **vstup (input)**.
2. Vydělíme 480 čtyřmi. To je postup neboli **algoritmus (algorithm)**.
3. Každá zaplatí 120 Kč. To je **výstup (output)**.

Když je zadání nejasné, nejdřív ho upřesni. „Pošli připomínku pozdě“ nestačí: komu a v kolik?

## První pohled na Javu

```java
System.out.println("Ahoj!");
```

Tento řádek vypíše `Ahoj!`. Zatím ho nemusíš umět napsat zpaměti.

**Java** je jazyk, ve kterém budeme pracovat. **JavaScript** je jiný jazyk; podobný název neznamená stejný kód.

V záložce **Cvičení** si teď zkus první úkol. Instalaci připravíme o pár lekcí dál.

## Co přesně počítači zadáváš

U společné večeře si částky zapíšeš jako čísla, jména hostů jako text a zaplacení jako ano/ne. Právě s těmito údaji bude pracovat program. Když mu zadáš „rozděl účet spravedlivě“, ještě neví, co udělat se zbytkem nebo s prázdným seznamem hostů. Tato rozhodnutí musíš doplnit do postupu.

Představ si účet 481 Kč pro čtyři lidi. Přesný podíl je 120,25 Kč. Pokud pracuješ jen s celými korunami, potřebuješ určit, kdo doplatí jednu zbývající korunu. Obě varianty mohou být správné, pokud odpovídají zadání. Program musí také vrátit výsledek, který odpovídá zadání.

## Jak číst ukázky v kurzu

Řádek `System.out.println(...)` je volání hotové **metody**, pojmenované operace. Hodnota v kulatých závorkách je její vstup, zde text. `System` je standardní třída Javy, `out` její konzolový výstup a `println` operace pro vypsání řádku. Podrobnou kostru spustitelného souboru rozebereme v [prvním programu](lesson:hello-world).

Krátké úryvky nejsou vždy celý soubor. Příkazy výpočtu a výpisu vkládáme do `main`, deklarace pomocných metod dovnitř třídy, ale mimo `main`, a importy nad třídu. Když ukázka uvádí vlastní `Main`, zkopíruj ji jako celek. Řádky s očekávaným výstupem nejsou další kód k opsání.

## Co přijde dál

Nejdřív zvládneš vstup, hodnoty, rozhodování a opakování. Potom rozdělíš program do metod a objektů. Následují kolekce, soubory, výjimky a zpracování dat. Nakonec program ověříš testy a připravíš ho ke spuštění na jiném počítači. Nové pojmy můžeš vyhledávat a vracet se k jejich příkladům; není potřeba znát je všechny při prvním pozdravu.

Zkus vlastní zadání: „Rozděl 90 minut mezi tři studijní bloky.“ Pojmenuj dva vstupy, operaci a výstup 30 minut. Pak změň počet bloků na nulu a vysvětli, proč zadání potřebuje další pravidlo.
