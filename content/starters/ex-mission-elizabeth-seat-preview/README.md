# Elizabeth hledá místa vedle sebe

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pýcha a předsudek · současná variace**

Elizabeth pomáhá Jane připravit místa na společné čtení v Longbournu. Někteří hosté přijdou spolu a chtějí také spolu sedět. Paní Bennet už nad plánkem zvažuje, koho by bylo společensky výhodné posadit vedle koho.

Elizabeth se pokusí jen vyhledat vhodný volný úsek, ale náhled ho rovnou zabere. Každé další rozmyšlení tak ubere další židle. Než se rodinné porady protáhnou do večera, musí být možné místa hledat bez toho, aby hledání samo vytvářelo rezervace.

</details>
<!-- aiva-story:end -->

Elizabeth Bennet plánuje místa pro společný večer. Náhled má vybrat první dostatečně dlouhý volný úsek, ale zatím nesmí potvrdit rezervaci v původním plánu.

## Tvůj zásah

Doplň preview(boolean[] occupied,int group). Po nalezení první vhodné skupiny už další místa nerezervuj.

## Připravené okolí

Převod vstupních čísel na boolean i výpis obstarává main. Pole uvnitř metody představuje jen návrh; nemusíš znát žádné rezervační API. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet míst 0–20, velikost skupiny 1–20 a stavy 0/1 (0 volné, 1 obsazené). Vrať nové boolean pole s první souvislou skupinou volných míst změněnou na true. Pokud se skupina nevejde, vrať nezměněnou kopii. Původní pole neměň. Main vypíše obě pole a porovná jejich totožnost.

Ukázkový vstup:

```text
5 2 0 1 0 0 0
```

Očekávaný výstup:

```text
Puvodni: [false, true, false, false, false]
Nahled: [false, true, true, true, false]
Stejne pole: false
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
