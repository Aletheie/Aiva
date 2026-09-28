# Spencer hledá nejdelší potvrzený úsek

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pretty Little Liars**

Spencer sestavuje časovou osu jednoho odpoledne. Má svědectví z kavárny, poznámku ze školy a několik časů, které zatím nikdo nepotvrdil. Hanna namítá, že ověřených úseků je přece dohromady dost.

Jenže mezi nimi zůstává mezera. V pátrání po zprávách od „A“ může právě taková chvíle změnit celý závěr. Spencer hledá nejdelší úsek, během kterého je pobyt daného člověka doložený bez přerušení.

</details>
<!-- aiva-story:end -->

Spencer Hastings skládá časovou osu z potvrzených a nepotvrzených úseků. Nejdelší souvislá potvrzená část je důležitější než počet potvrzení dohromady.

## Tvůj zásah

Doplň metodu longest(int[] verified). Musí zachytit i sérii končící posledním prvkem a nerozšířit ji přes nulu.

## Připravené okolí

Načtení pole je hotové. Udržuj průběžný začátek, délku a dosavadní nejlepší výsledek. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: délka 0–40 a hodnoty 0/1 v pořadí časových úseků. Jednička znamená potvrzení, nula přerušení. Vypiš Delka, Od a Do nejdelší souvislé série jedniček, indexy od nuly včetně obou krajů. Při shodné délce zvol dřívější sérii. Bez jedniček vrať 0, -1, -1. Vstupní pole neměň.

Ukázkový vstup:

```text
7 1 1 0 1 1 1 1
```

Očekávaný výstup:

```text
Delka: 4
Od: 3
Do: 6
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
