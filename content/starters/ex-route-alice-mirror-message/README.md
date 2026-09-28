# Alenka čte vzkaz ze zrcadla

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Alenka za zrcadlem**

Na druhé straně zrcadla objeví Alenka lístek s pozváním k další zastávce. Písmena vypadají povědomě, jen běží v opačném pořadí. Po předchozích setkáních ji už podobná zdvořilost příliš nepřekvapuje.

Tentokrát si chce připravit malou čtečku pro další obrácené vzkazy. Vyřeší kousek zprávy a stejnou práci přenechá menšímu zbytku, dokud už není co číst. Na šachovnici za zrcadlem ji čekají další políčka; Alenka by nejdřív ráda věděla, na které ji vlastně zvou.

</details>
<!-- aiva-story:end -->

V Alenčině vymyšlené poště za zrcadlem přicházejí vzkazy pozpátku. Napiš překladač, který vrátí jejich čitelnou podobu. Tentokrát si chce Alenka vyzkoušet rekurzi: každý krok vyřeší poslední znak a předá menší zbytek dál.

Doplň `reverse(String text, int index)`. Starter ji volá s indexem posledního znaku. Pro záporný index vrať prázdný řetězec; jinak spoj znak na tomto indexu s výsledkem rekurzivního volání pro předchozí index. Použij rekurzi bez cyklu a bez hotové metody reverse; samotná kontrola výstupu použitou konstrukci nepozná, zkontroluj ji také v editoru.

Vstup je jeden řádek o 0–120 běžných ASCII znacích včetně mezer. Záměrně neobracíme emoji ani složené znaky. Výstupem je jeden obrácený řádek. `!jac is jeD` se změní na `Dej si caj!`; mezery se nemažou. Prázdný řádek zůstane prázdný. Viz [rekurze](lesson:recursion).

## Spuštění

JDK 21 nebo novější. Otevři složku v editoru, doplň místa TODO a ulož soubory.
V Aiva spusť kontrolu uloženého kódu. Ručně můžeš ze složky cvičení spustit:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java
java -cp out Main
```
