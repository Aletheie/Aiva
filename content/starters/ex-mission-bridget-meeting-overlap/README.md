# Bridget má dvě schůzky ve stejný čas

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Deník Bridget Jones**

Bridget si konečně pořídila přehledný kalendář. Pracovní domluva, setkání s přáteli, čas na cestu: všechno má vlastní řádek. Pak si všimne dvou schůzek, které by musela absolvovat zároveň, nejlépe na opačných koncích Londýna.

Pokus o varování ale protestuje i proti schůzkám, které na sebe jen těsně navazují. Bridget nechce preventivně zrušit celý den. Chce upozornění jen tehdy, když se schůzky opravdu překrývají.

</details>
<!-- aiva-story:end -->

Bridget Jones plánuje dvě setkání. Potřebuje znát konce obou schůzek a zjistit, zda se překrývají; setkání navazující přesně na sebe jsou v pořádku.

## Tvůj zásah

Oprav konstruktor, end a overlaps třídy Meeting. Porovnání musí fungovat i když druhá schůzka začne dřív než první.

## Připravené okolí

Main už vytváří dva objekty a kontroluje překryv oběma směry. Nemusíš používat LocalTime; uložené minuty jsou obyčejná celá čísla. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: začátek a délka první schůzky, začátek a délka druhé. Časy jsou minuty od půlnoci, začátek 0–1439, délka 1–1440, konec nepřesáhne 1440. Constructor Meeting uloží obě hodnoty. end vrátí začátek plus délku. overlaps vrátí true jen při společném úseku kladné délky, intervaly jsou [začátek,konec).

Ukázkový vstup:

```text
600 60 630 45
```

Očekávaný výstup:

```text
Konce: 660,675
Prekryv: true
Obracene: true
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
