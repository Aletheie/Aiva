# Claire nepřipustí záporný sklad

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Resident Evil**

Claire vede výdej beden s vybavením pro evakuační tým. Zapisuje příjmy i výdeje a každou změnu ještě porovnává s regálem. Po dalším požadavku se na obrazovce objeví záporný sklad.

Zápornou bednu zatím nikdo nenaložil, takže Claire zastaví přípravu další dodávky. Současně zjistí, že se dá evidovat víc kusů, než se do skladu vejde. Potřebuje, aby samotná evidence bránila nemožným změnám, i když někdo u výdejního pultu zadá nesmysl.

</details>
<!-- aiva-story:end -->

Claire Redfield přijímá a vydává bedny vybavení. Někdo přidal jednoduchý setter zásoby a sklad může skončit pod nulou nebo nad fyzickou kapacitou.

## Tvůj zásah

Nahraď veřejný měnitelný stav třídy Crate soukromými poli. Doplň kontroly v take a add a ponech pouze getter amount.

## Připravené okolí

Main už převádí příkazy na volání metod. Vstupní kapacita a počáteční zásoba jsou platné; konstruktor je pouze uloží. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: kapacita 0–1000, počáteční zásoba 0 až kapacita, počet akcí 0–20 a dvojice TAKE/ADD s množstvím -1 až 1000. Každá operace přijme pouze kladné množství. TAKE uspěje jen s dostatečnou zásobou, ADD jen s dostatkem místa. Po každé akci main vypíše true/false a stav. Neúspěch musí ponechat stav.

Ukázkový vstup:

```text
10 5 4 TAKE 3 ADD 9 ADD 8 TAKE 10
```

Očekávaný výstup:

```text
true:2
false:2
true:10
true:0
Konec: 0
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
