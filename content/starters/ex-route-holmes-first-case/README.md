# Holmes hledá první spis se stejným kódem

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Sherlock Holmes · současná variace**

Watson v moderní verzi archivu z Baker Street seřadil spisy podle kódů. K jednomu případu patří více záznamů: původní poznámka, doplnění a další kopie. Holmes chce vždy začít tím prvním.

Rychlé hledání ho sice dovede ke správnému kódu, ale někdy až k pozdější položce. Watson už odmítá znovu procházet celý seznam od začátku. Archiv potřebuje využít své uspořádání a přitom nepřehlédnout starší záznamy se stejným označením.

</details>
<!-- aiva-story:end -->

Sherlock Holmes má archiv seřazený podle číselných kódů. Jeden případ může mít několik záznamů se stejným kódem. Potřebuje první z nich; procházet celý archiv při každém dotazu už Watsona nebaví.

Doplň `firstIndex(int[] codes, int wanted)` binárním vyhledáváním. Pole je seřazené vzestupně a může obsahovat duplicity. Vrať nejnižší index hledané hodnoty nebo -1, když chybí. Pole neměň a znovu netřiď. Při nalezení shody ještě prohledej levou část. Konstrukci ověř v editoru: automatické výstupy samy nedokazují logaritmickou složitost.

Vstup: počet prvků 0–100, daný počet celých čísel a hledané číslo. Všechny hodnoty jsou v rozsahu int. Pro `6 2 4 4 4 9 12 4` vyjde `1`. Pro `0 7` vyjde `-1`.

Vyzkoušej první i poslední pozici, několik stejných čísel a hledané číslo mezi dvěma existujícími. Viz [hledání a složitost](lesson:searching-and-complexity).

## Spuštění

JDK 21 nebo novější. Otevři složku v editoru, doplň místa TODO a ulož soubory.
V Aiva spusť kontrolu uloženého kódu. Ručně můžeš ze složky cvičení spustit:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java
java -cp out Main
```
