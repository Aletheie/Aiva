# Leonův soupis nesedí po přesunu beden

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Resident Evil**

Leon je zvyklý, že mapa Raccoon City slibuje cestu, která se nakonec nedá projít. Při nácviku evakuace proto raději předem rozdělí vybavení mezi dvě výdejní místa. Bedny se skutečně přestěhují, jen soupis na notebooku zůstane podivně optimistický.

Claire pošle fotografii téměř prázdného regálu. Podle programu je přitom materiálu dost na obou stanovištích. Leon by proti zdvojeným zásobám nic neměl, kdyby existovaly i mimo obrazovku. Tým potřebuje zjistit, kde se evidence při přesunu rozešla se skutečností.

</details>
<!-- aiva-story:end -->

Leon Kennedy přebírá sklad vybavení pro evakuační tým. Při přesunu beden program přepíše původní počet a část zásob se objeví ve dvou skladech současně.

## Tvůj zásah

V Main.java oprav přiřazení proměnných a výpočet kusů. Použij aktualizované hodnoty, ne původní součet z chybného místa.

## Připravené okolí

Scanner už přečetl a, b, moved a perBox. Načítání zatím nemusíš znát; pracuješ jen s celými čísly a jejich změnami. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Čtyři celá čísla: počet beden ve skladu A, ve skladu B, přesouvaný počet a počet kusů v bedně. Vše je 0–1000, přesun nepřekročí A. Přesuň bedny z A do B a vypiš nové počty a celkový počet kusů. Součet beden před a po se musí shodovat.

Ukázkový vstup:

```text
10 3 4 6
```

Očekávaný výstup:

```text
A: 6
B: 7
Kusy: 78
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
