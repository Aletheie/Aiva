# Marge odděluje dvě rozpočtové obálky

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Simpsonovi**

Marge rozdělila rozpočet do dvou obálek: jedna patří občerstvení, druhá výzdobě komunitního večera. Lisa jí připravila digitální přehled, aby nemusela pokaždé přepočítávat drobné. Homer už se ptá, do které kategorie patří další tác koblih.

Zkušební výběr z jedné obálky ale zasáhne i druhou a neúspěšná platba zanechá podivný zůstatek. Marge potřebuje vidět dvě samostatné částky. Jinak se velmi rychle stane, že peníze na ubrusy existují pouze v původním plánu.

</details>
<!-- aiva-story:end -->

Marge Simpson vede dvě obálky na různé akce. Výdaj z první nesmí ubírat peníze z druhé a nepovedený výdaj nesmí změnit žádný zůstatek.

## Tvůj zásah

Doplň instanční pole, konstruktor, spend a balance třídy Envelope. Žádný zůstatek nesmí být static.

## Připravené okolí

Main připravuje dvě instance a posloupnost operací. Tento kód i názvy veřejných metod zachovej; nahrazuje malou pokladní aplikaci. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počáteční částky obou obálek 0–10000 a dva požadavky na výdaj z první obálky (-1 až 10000). Envelope začíná předanou částkou. spend vrací true pouze pro kladnou částku nejvýše ve výši zůstatku a pak ji odečte. Nula i záporná částka vrací false. Main provede oba výdaje a vypíše jejich výsledky i oba zůstatky.

Ukázkový vstup:

```text
100 50 30 80
```

Očekávaný výstup:

```text
true
false
Prvni: 70
Druha: 50
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
