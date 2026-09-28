# Lisa počítá skutečně potvrzené směny

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Simpsonovi**

Lisa připravuje poděkování dobrovolníkům po komunitní akci. Marge odpracovala několik kratších směn, jiní přišli jednou a pár služeb se na poslední chvíli zrušilo. Homer navrhuje započítat i čas, kdy na pomoc intenzivně myslel.

Lisa chce přehled potvrzené práce. Každý člověk má dostat jeden součet svých skutečných směn, aby se neztratil mezi opakovanými řádky. Zrušený plán může zůstat v archivu, do odpracovaných hodin však nepatří.

</details>
<!-- aiva-story:end -->

Lisa Simpson připravuje přehled dobrovolnické práce. Zrušené směny se do odpracovaných hodin nepočítají a více směn jednoho člověka má tvořit jeden součet.

## Tvůj zásah

Doplň agregaci přes Stream API. Filtruj před seskupením a pracuj s hodinami, ne s počtem řádků.

## Připravené okolí

Main poskytuje List<Shift>. Collector groupingBy vytvoří skupiny, TreeMap řazení a summingInt jejich součty. Výpis a závěrečné součty jsou připravené. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet směn 0–40 a trojice jméno (slovo), hodiny 0–12, potvrzení true/false. Zahrň pouze potvrzené směny s kladným počtem hodin. Seskup podle jména, sečti hodiny, jména seřaď přirozeně. Vypiš jméno:hodiny, pak Celkem: součet a Lide: počet lidí v přehledu. Nulové a nepotvrzené směny nesmějí vytvořit prázdnou položku.

Ukázkový vstup:

```text
4 Marge 3 true Lisa 4 true Marge 2 true Bart 5 false
```

Očekávaný výstup:

```text
Lisa:4
Marge:5
Celkem: 9
Lide: 2
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
