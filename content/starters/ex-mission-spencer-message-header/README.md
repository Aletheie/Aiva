# Spencer odděluje odesílatele od zprávy

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pretty Little Liars**

Po další anonymní zprávě si Spencer vyžádá export z telefonů celé party. V Rosewoodu může stejné varování dorazit několika lidem v jinou chvíli a ona chce porovnat, co přesně kdo dostal.

Jenže hlavička se při zobrazení lepí k obsahu a mezery kolem oddělovače vytvářejí falešné rozdíly. Hanna už ukazuje dva údajně nové odesílatele; Spencer v nich vidí spíš dvě podoby stejného záznamu. Než začne hledat význam zpráv od „A“, potřebuje je vůbec správně přečíst.

</details>
<!-- aiva-story:end -->

Spencer Hastings porovnává archiv anonymních zpráv. Export používá jeden svislý oddělovač a nadbytečné mezery. Nejdřív potřebuje spolehlivě oddělit hlavičku od obsahu.

## Tvůj zásah

Oprav hranice substring a porovnání odesílatele. Index oddělovače je připravený; samotný oddělovač do zprávy nepatří.

## Připravené okolí

Main načetl line a našel separator přes indexOf. Ošetření neplatného formátu není součástí úlohy, vstupy mají slíbený oddělovač. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Jeden řádek má přesně jeden znak |. Před ním je neprázdné jméno po trim, za ním libovolný text bez dalšího |, případně prázdný. Očisti okraje obou částí, vnitřní mezery zachovej. Třetí řádek je true, pokud očištěný odesílatel odpovídá A bez rozlišení velikosti písmen.

Ukázkový vstup:

```text
  A |  Sejdeme se  v osm  
```

Očekávaný výstup:

```text
Od: A
Text: Sejdeme se  v osm
Anonym: true
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
