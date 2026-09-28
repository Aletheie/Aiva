# Jill rozděluje omezené zásoby

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Resident Evil**

Na výdejním místě čeká několik evakuačních týmů. Jill jim má rozdělit připravené sady a ví, že zásoby nevystačí na všechny požadavky. Před odesláním musí zkontrolovat, kolik sad může každý tým skutečně dostat.

Zkušební soupis ale poslednímu týmu přidělí plnou dávku, kterou už ve skladu nemají. Leon zvedne prázdnou přepravku jako poměrně přesvědčivý protiargument. Teď je potřeba srovnat postup rozdělování s tím, co po předchozích týmech skutečně zbývá.

</details>
<!-- aiva-story:end -->

Jill Valentine rozděluje sady vybavení mezi týmy v pořadí žádostí. Některým zásoby vystačí, poslední může dostat jen část. Program teď vydává víc, než má ve skladu.

## Tvůj zásah

Doplň cyklus, ubírání zásob a počítání neuspokojených týmů. Pořadí žádostí zachovej.

## Připravené okolí

Main přečetl počet týmů a sklad. V cyklu načteš každý požadavek připraveným input.nextInt(); samotný Scanner nemusíš rozebírat. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet týmů 0–20, počáteční sklad 0–1000, pak požadavek každého týmu 0–1000. Postupně vydej minimum požadavku a zbývajícího skladu. Pro každý tým vypiš Tym i: X, číslováno od 1. Nakonec Zbyva: X a Neuspokojeno: Y, kde Y je počet týmů, které nedostaly vše. Nulový požadavek je plně splněný.

Ukázkový vstup:

```text
3 10 4 8 1
```

Očekávaný výstup:

```text
Tym 1: 4
Tym 2: 6
Tym 3: 0
Zbyva: 0
Neuspokojeno: 2
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
