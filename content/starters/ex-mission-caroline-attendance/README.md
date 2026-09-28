# Caroline má hosty, ale nula procent účasti

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Upíří deníky**

Caroline připravuje další společenskou akci v Mystic Falls. Výzdoba drží, seznam úkolů má barevné značky a první hosté už stojí u registrace. Jediná znepokojivá věc je přehled na notebooku: stále tvrdí, že účast je nulová.

Bonnie se rozhlédne po zjevně neprázdném sále. Caroline odmítá přijmout vysvětlení, že jde o velmi tichou nadpřirozenou událost. Dokud čísla nesedí, těžko odhadne další porce občerstvení. Počty hostů jsou správné; záhada se skrývá v jejich převodu na procenta.

</details>
<!-- aiva-story:end -->

Caroline Forbes chystá večer v Mystic Falls. Někteří hosté už přišli, přehled ale pořád ukazuje účast 0 %. A i délka čekání v minutách ztrácí desetinnou část.

## Tvůj zásah

Oprav obě dělení. Vstupní počty ponech jako int; desetinné výsledky musí vzniknout už během výpočtu.

## Připravené okolí

Načítání a závěrečný výpis jsou připravené. Měníš pouze výrazy proměnných percent a minutes. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Tři čísla: počet příchozích 0–1000, počet potvrzených 1–1000 a součet jejich čekání v sekundách 0–1000000. Příchozích nikdy není více než potvrzených. Účast je arrived / confirmed * 100 jako double. Druhý výstup je čekání přepočtené na minuty, bez zaokrouhlování. Nejde o průměr na hosta.

Ukázkový vstup:

```text
3 4 90
```

Očekávaný výstup:

```text
Ucast: 75.0
Minuty: 1.5
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
