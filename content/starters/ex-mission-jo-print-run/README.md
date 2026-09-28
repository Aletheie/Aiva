# Jo March počítá větší náklad

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Malé ženy · současná variace**

Jo píše u malého stolku, Amy navrhuje obálku a Meg se ptá, kolik papíru bude potřeba pro všechna plánovaná vydání. V této současné variaci na Malé ženy dostala Jo z tiskárny obrovský zkušební přehled nákladů a pustila se do součtu.

Výsledek vychází záporný. Jo je ochotná škrtat celé odstavce, ale záporný počet vytištěných stran připadá příliš avantgardní i jí. Než přijme nabídku tiskárny, potřebuje ověřit, zda se její velké číslo vůbec vejde do připravené proměnné.

</details>
<!-- aiva-story:end -->

Jo March z Malých žen dostala souhrn několika vydání knihy. Program pro velký náklad vrací záporný počet stran, přestože každý vstup je kladný.

## Tvůj zásah

Zvol pro copies a pagesTotal vhodný celočíselný typ. Výsledek nesmí ztratit přesnost ani přetéct při samotném násobení.

## Připravené okolí

Texty dvou čísel už jsou načtené. Long.parseLong načte long; Integer.parseInt načte int. Připravené volání můžeš změnit, okolní Scanner ponech. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet výtisků 0–20000000 a stran na výtisk 1–1000. Vypiš počet výtisků a celkový počet vytištěných stran. Celková hodnota může přesáhnout rozsah int.

Ukázkový vstup:

```text
10000000
400
```

Očekávaný výstup:

```text
Vytisky: 10000000
Strany: 4000000000
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
