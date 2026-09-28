# Damon si musí vybrat správný okamžik

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Upíří deníky**

Bonnie našla záznam, který by mohl pomoci s pátráním v Mystic Falls, a Damon ho má vyzvednout. Domluva vypadala jednoduše, než do ní vstoupilo pozvání do domu, denní světlo a zpráva o poplachu. Damon navíc považuje kontrolu detailů za práci někoho méně okouzlujícího.

V připravené simulaci proto vznikl malý přehled, který rozhodne, zda může předání proběhnout. Několik okolností se ale může sejít zároveň. Damon potřebuje zjistit, které pravidlo má přednost, aby věděl, kdy může archiv vyzvednout.

</details>
<!-- aiva-story:end -->

Damon Salvatore domlouvá předání archivu. V této příběhové simulaci záleží na pozvání, poplachu, hodině a ochranném prstenu. Několik pravidel může platit současně; rozhoduje jejich pořadí.

## Tvůj zásah

Oprav prioritu a hranice podmínek. Nestačí otestovat jen den s prstenem a noc bez něj.

## Připravené okolí

Načítání čtyř hodnot je hotové. Nepotřebuješ pracovat s datem ani časovou knihovnou; hodina je celé číslo. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Na vstupu je hodina 0–23, pozvání, poplach a prsten (true/false). Bez pozvání vypiš ODMITNUTO. Jinak při poplachu CEKEJ. Jinak ve dne bez prstenu také vypiš CEKEJ. Den trvá od 6 včetně do 18 výlučně. Ve všech ostatních případech vypiš VYRAZIT. Vždy právě jeden řádek.

Ukázkový vstup:

```text
18 true false false
```

Očekávaný výstup:

```text
VYRAZIT
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
