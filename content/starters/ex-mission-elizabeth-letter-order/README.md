# Elizabeth řadí dopisy podle tří pravidel

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pýcha a předsudek · současná variace**

V Longbournu přibyla hromádka dopisů. Jane čeká na odpověď k návštěvě, Charlotte poslala praktickou zprávu a další korespondence může chvíli počkat. Paní Bennet navrhuje začít tím dopisem, jehož odesílatel je společensky nejzajímavější.

Elizabeth se rozhodne pro předvídatelnější pořadí. Naléhavost má přednost, při shodě pomůže stáří a nakonec jméno. Digitální přehled ale zatím tato hlediska zaměňuje. Chce mít navrchu dopisy, na které je potřeba odpovědět nejdřív.

</details>
<!-- aiva-story:end -->

Elizabeth Bennet potřebuje přehled dopisů, který upřednostní naléhavé zprávy. Mezi stejně naléhavými mají jít starší dopisy dřív a jméno rozhodne až poslední shodu.

## Tvůj zásah

Oprav složený Comparator<Letter>. Pozor na reversed na konci, které by obrátilo i předchozí pravidla.

## Připravené okolí

Main načítá dopisy a používá tvůj komparátor v připraveném sorted. Letter má sender(), urgent() a days(); výpis ani zdrojový seznam neměň. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet dopisů 0–20 a trojice odesílatel (slovo), naléhavost true/false, stáří ve dnech 0–365. Seřaď: naléhavé první, potom větší stáří první, potom jméno vzestupně. Výstup obsahuje jména v tomto pořadí, každý na řádku; prázdný seznam dá BEZ DOPISU. Duplicity zachovej.

Ukázkový vstup:

```text
4 Jane true 2 Emma false 30 Anna true 2 Jo true 5
```

Očekávaný výstup:

```text
Jo
Anna
Jane
Emma
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
