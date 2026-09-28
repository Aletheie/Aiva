# Caroline opravuje zvýhodněnou vstupenku

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Upíří deníky**

Caroline připravila pro komunitní večer i zvýhodněné vstupenky. Mají mít všechny běžné údaje, jen navíc vlastní označení a upravenou cenu. Bonnie pomáhá s kontrolou a porovnává kartičky vedle sebe.

Na nové variantě chybí část údajů z obyčejného lístku a cena se počítá z nesprávného základu. Caroline nepotřebuje budovat druhou evidenci hostů. Chce rozšířit stávající vstupenku, aby i zvýhodněný lístek uváděl správnou majitelku a cenu.

</details>
<!-- aiva-story:end -->

Caroline Forbes má běžnou a zvýhodněnou vstupenku. Odvozená varianta má zachovat jméno i základní cenu předka, přidat označení a teprve potom odečíst slevu.

## Tvůj zásah

Oprav konstruktor a přepsané metody DiscountPass. Jméno ani základní cenu neukládej do druhých polí; použij super.

## Připravené okolí

Třída Pass se soukromými poli, label a price už je hotová. Main vytváří oba objekty a nepotřebuje žádné změny. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: celé jméno na řádku, základní cena 0–10000 a sleva 0–10000. Standardní Pass vrací základní cenu a jméno. DiscountPass má label jméno + /zvyhodnena a cenu max(0,základ-sleva). Main vypíše oba průkazy.

Ukázkový vstup:

```text
Caroline
300 80
```

Očekávaný výstup:

```text
Caroline:300
Caroline/zvyhodnena:220
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
