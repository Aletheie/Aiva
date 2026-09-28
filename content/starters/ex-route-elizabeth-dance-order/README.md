# Elizabeth zachrání pořadí tanečních karet

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pýcha a předsudek · současná variace**

Při přípravě tanečního večera má Elizabeth dvě důležité hromádky: seznam příchozích a taneční karty. Pan Collins ochotně nabídne vlastní pořadí, které se až podezřele dobře shoduje s tím, kdy přišel on.

Domluvené řazení ale vychází z počtu rezervovaných tanců a při shodě ze jména. Elizabeth potřebuje nový přehled, zatímco původní seznam zůstane u dveří.

</details>
<!-- aiva-story:end -->

Elizabeth Bennet z Pýchy a předsudku pořádá přátelský taneční večer. Pan Collins chce rozdat karty podle svého pořadí příchodu, ale domluvené pravidlo je jiné: více rezervovaných tanců první, při shodě jméno vzestupně. Původní seznam se musí zachovat pro kontrolu u dveří.

Doplň `ordered(List<Guest> original)`. Vrať nový seznam seřazený podle dances sestupně, potom podle name vzestupně přes přirozené pořadí String. Použij Comparator a thenComparing; řazení proveď na kopii. Jména jsou v této úloze ASCII bez středníků a nepoužíváme české abecední řazení.

Vstup: počet hostů 0–30 a řádky `jmeno;pocetTancu`, počet tanců 0–100. Pro vstup:

```text
3
Collins;2
Darcy;4
Bingley;4
```

má vyjít:

```text
Bingley: 4
Darcy: 4
Collins: 2
Puvodni prvni: Collins
```

Poslední řádek vypisuje připravený Main z původního seznamu, proto jej neměň. U prázdného seznamu vypíše `Puvodni prvni: -`. Viz [Comparator](lesson:sorting-and-comparators).

## Spuštění

JDK 21 nebo novější. Otevři složku v editoru, doplň místa TODO a ulož soubory.
V Aiva spusť kontrolu uloženého kódu. Ručně můžeš ze složky cvičení spustit:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java
java -cp out Main
```
