# Jo nesmí přepsat odevzdanou verzi

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Malé ženy · současná variace**

Jo odešle rukopis do redakce a téměř okamžitě ji napadne lepší věta. Amy už má přečtenou starší verzi, redakce jinou a Jo by nejraději opravovala všechny naráz. V současné variaci příběhu jí s verzemi pomáhá malý program.

Odevzdanou verzi už Jo nemá měnit, dokud rukopis nestáhne zpět. První pokus o stažení však smaže i hotové stránky. Jo chce získat možnost psát dál, nikoli prožít začátek celého rukopisu ještě jednou.

</details>
<!-- aiva-story:end -->

Jo March posílá rukopis redakci. Dokud je odevzdaný, úpravy jsou uzamčené. Stažení rukopisu dovolí pokračovat, ale nesmí vymazat napsané stránky ani číslo verze.

## Tvůj zásah

Oprav přechody třídy Manuscript. Odliš verzi obsahu od změny pracovního stavu.

## Připravené okolí

Main už převádí příkazy a formátuje stav přes gettery. Veškerá pravidla mají být v Manuscript; konzolový kód ponech. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup tvoří počet akcí 0–20 a příkazy ADD n, SUBMIT, WITHDRAW. Přírůstek n je -1 až 100. ADD uspěje pouze pro kladné n v rozepsaném stavu: přidá stránky a zvýší verzi o 1. SUBMIT uspěje jen pro neprázdný, dosud neodevzdaný rukopis. WITHDRAW uspěje jen po odevzdání. Neúspěch nic nezmění. Po každé akci vypiš výsledek a pages/version/submitted.

Ukázkový vstup:

```text
5 ADD 10 SUBMIT ADD 2 WITHDRAW ADD 2
```

Očekávaný výstup:

```text
true:10/1/false
true:10/1/true
false:10/1/true
true:10/1/false
true:12/2/false
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
