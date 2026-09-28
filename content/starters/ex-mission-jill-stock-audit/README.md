# Jill hledá sklad s nejmenší zásobou

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Resident Evil**

Jill před cvičnou evakuací porovnává zásoby na několika stanovištích. Nestačí jí vědět, že je vybavení celkově dost; jeden osamělý tým může mít téměř prázdný sklad, zatímco jinde zůstávají plné regály.

Souhrnný přehled všechno slije do uklidňujícího čísla. Jill si proto vyžádá i výčet slabých míst a první nejhůře zásobené stanoviště. Ráda by poslala pomoc tam, kde chybí, ještě předtím, než z vysílačky uslyší, že další sada už opravdu není.

</details>
<!-- aiva-story:end -->

Jill Valentine porovnává zásoby několika skladů. Potřebuje celkový součet, počet míst pod bezpečnostním limitem a první sklad s nejnižší zásobou.

## Tvůj zásah

Oprav metodu audit(int[] stock,int limit). Všechny tři výsledky spočítej jedním průchodem.

## Připravené okolí

Main načte pole a zavolá audit. Jeho načítací cyklus ani pole nemusíš měnit. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet skladů 0–30, limit 0–1000 a zásoby 0–1000. Vypiš Celkem, Pod limitem (ostře méně než limit) a Nejnizsi index. Indexy začínají nulou; při shodě vyber první. Pro prázdné pole jsou součet i počet 0 a index -1. Pole neměň.

Ukázkový vstup:

```text
4 5 8 2 5 2
```

Očekávaný výstup:

```text
Celkem: 17
Pod limitem: 2
Nejnizsi index: 1
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
