# William řeší vrácení knihy

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Notting Hill**

Ve Williamově cestovatelském knihkupectví se zákazníci ptají na vzdálené země, zatímco Martin hledá ztracenou účtenku přímo pod pultem. Do toho někdo přinese knihu zpět. William chce rozhodnout slušně a hlavně pokaždé stejně.

Pro tuto cvičnou verzi obchodu proto sepsal jednoduché podmínky vrácení. První program je však posuzuje v podivném pořadí a různé důvody si navzájem přepisují výsledek. Než do obchodu vejde další nečekaná návštěva, rád by měl aspoň u této otázky jasno.

</details>
<!-- aiva-story:end -->

William Thacker z Notting Hillu potřebuje sjednotit rozhodování v knihkupectví. Jde o vymyšlená pravidla této prodejny, ne o právní pravidla reklamací.

## Tvůj zásah

Oprav rozhodovací řetězec tak, aby přednější pravidlo nemohlo být přepsáno pozdější větví.

## Připravené okolí

Hodnoty už jsou načtené. Složitější zákaznický systém je mimo tento úsek; měníš jen pravidlo rozhodnutí. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet dní od nákupu (-1 až 60), účtenka true/false a nepoškozený obal true/false. Záporný počet dní vrací CHYBA. S účtenkou do 14 dní včetně vrací PENIZE bez ohledu na obal. Jinak do 30 dní včetně s nepoškozeným obalem vrací VYMENA. Ostatní případy vrací ODMITNUTO. Každé rozhodnutí má jediný řádek.

Ukázkový vstup:

```text
14 true true
```

Očekávaný výstup:

```text
PENIZE
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
