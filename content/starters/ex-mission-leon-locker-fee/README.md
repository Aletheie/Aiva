# Leon potřebuje cenu za skutečný čas

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Resident Evil**

Leon uložil vybavení do pronajatých skříněk, než tým dokončí přesun. Původně mělo jít o krátkou zastávku, jenže objížďka a zavřený průjezd plán protáhly. Teď má vyzvednout věci a převzít účet.

Ceník počítá s bezplatným začátkem a dalšími časovými bloky. Připravená kalkulačka však účtuje i dobu, kterou účtovat nemá. Leon už během služby řešil dost neprůhledných zařízení; tentokrát by rád rozuměl aspoň tomu, za jak dlouhé uložení skutečně platí.

</details>
<!-- aiva-story:end -->

Leon Kennedy vyzvedává uložené vybavení. Sklad účtuje první dvě hodiny zdarma a potom každé započaté tři hodiny za každou skříňku. Kalkulačka nyní počítá i bezplatný úsek.

## Tvůj zásah

Oprav static int fee(int hours,int lockers). Odděl bezplatný čas od placených bloků a zahrň započatý poslední blok.

## Připravené okolí

Main i formát výpisu jsou hotové. Pracuješ pouze s metodou; časovou knihovnu není třeba znát. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet hodin 0–1000 a skříněk 0–20. Za čas nad dvě hodiny účtuj 25 za každý započatý blok tří hodin a skříňku. Metoda fee vrací int a nic nevypisuje. Main vypíše jedinou cenu.

Ukázkový vstup:

```text
6 2
```

Očekávaný výstup:

```text
100
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
