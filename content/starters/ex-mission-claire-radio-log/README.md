# Claire odděluje opakování od nové zprávy

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Resident Evil**

Claire zapisuje hlášení evakuačního týmu, zatímco ve vysílačce praská spojení. Stejná věta někdy přijde několikrát po sobě, protože odesílatel neví, zda ji někdo slyšel. O chvíli později může mít stejné znění už úplně nové hlášení.

V přehledu se obojí slilo dohromady. Leon podle něj nedokáže poznat, co se skutečně opakovalo a co mezitím přibylo. Claire nechce ticho zaměnit za zprávu ani z rádiového echa vyrábět další události. Potřebuje deník, který zachová průběh spojení.

</details>
<!-- aiva-story:end -->

Claire Redfield přepisuje hlášení z vysílačky. Opakování stejného hlášení nemá vytvářet nové události, ale přehled má uvést, kolikrát se hlášení opakovalo.

## Tvůj zásah

Oprav ukončení cyklu a aktualizaci poslední zprávy. Nepřepisuj poslední zprávu prázdným řádkem.

## Připravené okolí

Scanner dodává textové řádky. Pracuješ s while, trim, equals a jednoduchými počítadly; síť ani skutečné rádio zde neběží. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Čti řádky až po END po oříznutí okrajů. END je vždy přítomné a nezapočítává se; text po něm nečti. Prázdné řádky ignoruj. Stejná neprázdná zpráva jako poslední přijatá zvýší opakování, jiná zvýší počet zpráv a nahradí poslední. Prázdný řádek nepřeruší porovnávání. Velikost písmen rozlišuj. Bez zpráv je poslední znak -. Vypiš Zpravy, Opakovani a Posledni.

Ukázkový vstup:

```text
A
A

B
A
END
```

Očekávaný výstup:

```text
Zpravy: 3
Opakovani: 1
Posledni: A
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
