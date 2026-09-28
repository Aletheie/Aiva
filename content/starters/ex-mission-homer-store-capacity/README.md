# Homer objednal víc, než se vejde do skladu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Simpsonovi**

Homer se nabídl, že před komunitním večerem převezme krabice občerstvení. Marge mu ukázala jediný volný regál a zdůraznila, že chodba musí zůstat průchozí. Homer mezitím kývl i na další dodávku.

Skladový program přijme všechno a až potom řeší výdej. Výsledek vypadá úhledně, skutečné krabice však stojí přede dveřmi. Marge potřebuje vědět, kolik se dalo opravdu uložit a kolik vydat. Homerův návrh sníst přebytek se zatím do pravidel nezařadil.

</details>
<!-- aiva-story:end -->

Homer Simpson objednal občerstvení na několik směn. Ráno dorazí nová várka, část se nevejde do skladu a až potom si směna vyzvedne svou objednávku.

## Tvůj zásah

Oprav simulaci tak, aby odpovídala pořadí ranní dodávky a pozdějšího výdeje. Sleduj tři oddělené součty.

## Připravené okolí

Načítání je připravené. Math.min vrací menší hodnotu, Math.max větší; můžeš je nahradit podmínkami. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Pět čísel: počet dní 0–31, kapacita 0–1000, počáteční zásoba 0 až kapacita, denní dodávka 0–1000 a denní požadavek 0–1000. Každý den nejprve přičti dodávku; přebytek nad kapacitu započti jako odložený a sklad omez na kapacitu. Pak vydej nejvýše denní požadavek. Na konci vypiš Zasoba, Vydano a Odlozeno.

Ukázkový vstup:

```text
2 10 8 5 4
```

Očekávaný výstup:

```text
Zasoba: 6
Vydano: 8
Odlozeno: 4
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
