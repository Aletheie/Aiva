# Claire skládá dva pohledy na zásoby

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Resident Evil**

Claire připravuje zásoby pro lidi čekající na evakuaci. Nejprve potřebuje odložit vše, co už není použitelné, a teprve ze zbytku zjistit, čeho je málo. Na stole leží dva výpisy, které se však neshodnou ani na první otázce.

Jeden považuje položku za připravenou k výdeji, druhý ji vede mezi nevhodnými. Claire nechce objednávat doplnění podle protichůdných přehledů. Oba pohledy musejí vycházet ze stejného pravidla použitelnosti a lišit se až tím, na co se dál ptají.

</details>
<!-- aiva-story:end -->

Claire Redfield potřebuje přehled použitelných zásob a z něj vybrat položky, které je potřeba doplnit. Dva filtry nemají používat různá pravidla použitelnosti.

## Tvůj zásah

Oprav Predicate usable a vytvoř lowStock jeho složením pomocí and. Metodu select neměň a neduplikuj celou kontrolu použitelnosti.

## Připravené okolí

Supply poskytuje name(), stock() a days(). Připravený select prochází seznam a aplikuje pravidlo; naopak tělo lambdy se provádí až při testování položky. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet položek 0–20 a trojice název, kusy 0–100, dny do konce použitelnosti -30 až 30. Názvy jsou jedinečná slova. Použitelné mají kusy >0 a dny >=0. K doplnění jsou z použitelných ty s méně než 5 kusy. Zachovej vstupní pořadí. Main vytiskne oba seznamy názvů.

Ukázkový vstup:

```text
4 Radio 4 0 Light 5 2 Empty 0 4 Old 2 -1
```

Očekávaný výstup:

```text
Pouzitelne: [Radio, Light]
Doplnit: [Radio]
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
