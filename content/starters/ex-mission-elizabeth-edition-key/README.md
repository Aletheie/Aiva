# Elizabeth rozlišuje jazyková vydání

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pýcha a předsudek · současná variace**

Elizabeth doplňuje do knihovny překlady pro společné čtení. Jane si vybrala jedno jazykové vydání, Charlotte jiné a obě chtějí později porovnat oblíbenou pasáž. Moderní katalog však jejich výtisky sloučí.

Název díla sedí, identifikátor také, jen jazyk jako by neexistoval. Elizabeth dobře ví, že dvě podoby téhož příběhu nejsou při půjčování automaticky zaměnitelné. Potřebuje, aby katalog poznal konkrétní vydání a nepřepsal jednu čtenářskou volbu druhou.

</details>
<!-- aiva-story:end -->

Elizabeth Bennet si všimla, že katalog sloučil dvě jazyková vydání. Identifikátor knihy sám nestačí: součástí hodnoty je i jazyk.

## Tvůj zásah

Doplň neměnný typ Edition s korektním equals a hashCode pro dva údaje. Nedomnívej se, že různé objekty musejí mít vždy různý hash.

## Připravené okolí

Main obsahuje připravenou kolekci a kontrolu kopie. Upravuješ porovnávání a kopírování údajů o vydání knihy. Kolekce už je připravená. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Čtyři řádky: kód a jazyk první položky, kód a jazyk druhé. Vše neprázdné po trim; kód zachová velikost i nuly, jazyk se normalizuje na velká písmena Locale.ROOT. Edition je rovná pouze další Edition se shodným kódem i jazykem. Main porovná hodnoty, uloží obě do Set a dohledá čerstvou kopii první.

Ukázkový vstup:

```text
K1
cs
K1
en
```

Očekávaný výstup:

```text
Rovne: false
Pocet: 2
Kopie nalezena: true
Hash kopie: true
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
