# Enola řeší dvě třídy se stejným názvem

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Enola Holmes · současná variace**

Enola třídí archiv případů a vedle detektivních poznámek přebírá i několik obyčejných souborů. Ve vlastní práci ráda hledá nečekané významy, jenže dva různé objekty pojmenované stejně jí tentokrát příliš nepomáhají.

Když chce vytisknout štítek případu, editor nabízí práci s cestou na disku. Digitální archiv se chová, jako by si spletl zavazadlo s jeho obsahem. Enola potřebuje rozlišit vlastní třídu pro spis od třídy pro práci se soubory.

</details>
<!-- aiva-story:end -->

Enola Holmes třídí digitální archiv. Kolega pojmenoval její vlastní složku `File`, jiný přidal `java.io.File` a editor teď nabízí úplně jiné metody. Připrav srozumitelné názvy a balíček, aby Enola mohla znovu vytisknout štítek případu.

Ve starteru jsou `Main.java` a `holmes/archive/CaseFile.java`. V pomocném souboru chybí deklarace balíčku a přístup k metodě, v Main import. Oprav deklarace tak, aby Main mohl vytvořit CaseFile a zavolat `label`. Pole ani výstupní text nepřesouvej do Main a nepoužívej wildcard import.

Spusť program z terminálu podle README, i když editor nabízí zelené tlačítko. Musí vypsat přesně:

```text
Pripad: Zmizela violoncella
```

Potom v Main změň jen název případu na `Ztraceny kufr`; výsledný štítek se musí změnit bez úpravy CaseFile. Záměrně na chvíli odeber `public` z metody: vysvětli, proč import sám přístup nepovolí, a deklaraci zase oprav. Znalost filmu není potřeba; archiv je pro tuto misi vymyšlený. Viz [balíčky a importy](lesson:packages-and-imports).

## Spuštění

JDK 21+, příkazy spusť ze složky cvičení. Kontrola v Aiva je ruční.

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java src/main/java/holmes/archive/CaseFile.java
java -cp out Main
```

## Ověření

- Oba soubory se přeloží uvedeným javac příkazem.
- Výpis pro původní i změněný název odpovídá zadání.
- CaseFile má správný package a public metodu; Main ji importuje.
- Umím vysvětlit rozdíl mezi importem a přístupem public.
