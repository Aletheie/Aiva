# Aria hlídá kolize v ateliéru

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pretty Little Liars**

Aria domluvila společný ateliér pro fotografování a výtvarné projekty. Ve dnech, kdy se zrovna nepátrá po dalších zprávách od „A“, by ráda měla místo, kde se dá v klidu pracovat. Každý si má předem rezervovat čas.

Jenže rezervace z formuláře a z jednoduchého menu se kontrolují jinak. Dvě skupiny přijdou ve stejnou chvíli a obě ukazují potvrzení. Aria potřebuje, aby rozvrh platil stejně pro všechny vstupy, nejen pro ten, který právě používala ona.

</details>
<!-- aiva-story:end -->

Aria Montgomery sdílí ateliér s dalšími lidmi. Potřebuje model rezervací, který funguje i bez konzolového menu a nepovolí dvě souběžná setkání.

## Tvůj zásah

Doplň Diary.reserve a size. Kontroly musí být v modelu, ne jen v parseru. Nesmí se uložit ani duplicitní interval.

## Připravené okolí

Slot je připravený záznam se start() a end(). List je zde hotové úložiště; pro řešení stačí průchod for-each, add a size. Jeho vnitřní implementaci nepotřebuješ znát. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Na vstupu je počet žádostí 0–20 a dvojice začátek/konec v minutách od půlnoci (-1 až 1441). Platný interval splňuje 0 <= začátek < konec <= 1440. Rezervace jsou [začátek,konec), takže návaznost nevadí. Přijmi žádost pouze bez překryvu se všemi dříve přijatými. Každá vrací true/false; odmítnutá se neuloží. Na konci vypiš Pocet: X.

Ukázkový vstup:

```text
4 600 660 660 700 630 640 500 610
```

Očekávaný výstup:

```text
true
true
false
false
Pocet: 2
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
