# Elizabeth přidává digitální vydání

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pýcha a předsudek · současná variace**

Elizabeth rozšiřuje čtenářský katalog, aby si Jane mohla přibalit knihy i bez dalšího kufru. V této současné variaci rodinná knihovna nabízí také digitální vydání. Mary okamžitě začne plánovat, kolik jich zvládne během návštěvy přečíst.

Elektronická kniha má pořád název a stránky, navíc se ale sleduje počet zařízení. První návrh tyto údaje odděluje tak nešikovně, že se známé informace ztrácejí. Elizabeth chce novou možnost přidat ke knihám, které už katalog umí popsat.

</details>
<!-- aiva-story:end -->

Elizabeth Bennet rozšiřuje katalog o digitální knihy. Každé vydání má stále název a počet stran, ale digitální verze navíc omezuje počet současných zařízení.

## Tvůj zásah

Doplň EBook bez kopírování polí title a pages. Přidej vlastní pole limit a použij zděděné chování.

## Připravené okolí

Book už poskytuje summary a pages. Načtení a výpis v main jsou připravené. Není potřeba pracovat se skutečnými licencemi nebo soubory knih. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: název, počet stran 1–10000, povolená zařízení 1–10 a požadovaný počet zařízení 0–20. EBook dědí Book. Jeho summary vrátí původní summary doplněné o /digital. canReadOn vrátí true pro počty 1 až limit včetně. Nula není platný požadavek. Main vypíše shrnutí, strany a rozhodnutí.

Ukázkový vstup:

```text
Emma
400 2 2
```

Očekávaný výstup:

```text
Emma/400/digital
Strany: 400
Povoleno: true
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
