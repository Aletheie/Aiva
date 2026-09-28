# Jo dopisuje rukopis po částech

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Malé ženy · současná variace**

Jo si vyhradila večer na rukopis. Beth cvičí, Amy potřebuje radu k obrázku a někdo neustále hledá jediný použitelný list papíru. Přesto po malých částech přibývají další stránky.

V současné variaci příběhu si Jo vede jednoduchý přehled psaní. Některé zápisy znamenají hotový kus práce, jiné jen přestávku a jeden ukončení večera. Program zatím tyto situace směšuje. Jo chce vědět, kdy dosáhla svého cíle, aniž by jí počítadlo připisovalo kapitoly, které nikdy nenapsala.

</details>
<!-- aiva-story:end -->

Jo March chce sledovat postup práce, dokud nedosáhne cílového počtu stran. Nulový přírůstek není napsaná kapitola a odložení práce musí program ukončit bez dalšího čtení.

## Tvůj zásah

Doplň podmínku cyklu, ukončení a dvě počítadla. Cíl se má kontrolovat proti celkovému součtu, ne poslední části.

## Připravené okolí

Main už přečetl goal. Další číslo načteš input.nextInt; ostatní stav spravuješ v označeném bloku. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Nejdřív přijde cíl 0–1000 stran. Pak přírůstky 0–100 nebo -1 pro odložení. Čti do dosažení cíle nebo -1. Započítej všechny napsané strany i případné překročení cíle; počet částí roste pouze pro kladné přírůstky. Vypiš Strany, Casti a Hotovo jako boolean. Pro cíl 0 nečti žádný přírůstek. Vstup obsahuje dost dat k ukončení.

Ukázkový vstup:

```text
10 3 0 8
```

Očekávaný výstup:

```text
Strany: 11
Casti: 2
Hotovo: true
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
