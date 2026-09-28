# Leon porovnává dvě cesty přepravy

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Resident Evil**

Leon potřebuje dostat vybavení na další stanoviště. Některými cestami projde pěší kurýr, jiné dovolují použít dodávku. Všechno záleží na trase a množství beden; jediný univerzální odhad by byl příliš pohodlný.

Do přehledu proto přibyly dvě přepravní možnosti s různým výpočtem ceny. Leon chce nabídky porovnat vedle sebe, aniž by souhrn znal každý detail jejich pravidel. V terénu bude rozhodovat cesta; v programu má příslušný výpočet zajistit zvolený dopravní prostředek.

</details>
<!-- aiva-story:end -->

Leon Kennedy vybírá způsob přepravy beden. Pěší kurýr a dodávka počítají cenu jinak, ale přehled má jejich nabídky zpracovat stejným voláním.

## Tvůj zásah

Oprav metody cost ve třídách FootCourier a Van. Výpočet se má vybrat polymorfně; hlavní cyklus neměň.

## Připravené okolí

Transport je hotový společný abstraktní typ. Main drží obě varianty v jednom poli a volá name a cost bez znalosti jejich vnitřního výpočtu. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: vzdálenost 0–50 a bedny 0–30. Pěší kurýr vezme nejvýše dvě bedny za cenu 3*vzdálenost, při více vrátí -1. Dodávka veze deset beden na jízdu; každá započatá jízda stojí 2*vzdálenost+5. Pro nula beden obě možnosti vracejí 0. Jde o herní jednotky. Main vypíše obě ceny.

Ukázkový vstup:

```text
10 11
```

Očekávaný výstup:

```text
Pesky:-1
Dodavka:50
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
