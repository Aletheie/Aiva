# Jo předává rukopisy redaktorce v pořadí

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Malé ženy · současná variace**

Jo dorazí k redaktorce s dalšími texty a zjistí, že na stole je místo jen pro dva čekající rukopisy. Ten nejstarší má přijít na řadu první. Amy navrhne udělat na obálkách větší obrázky; Jo by raději zabránila tomu, aby se nějaký text ztratil.

V současné verzi příběhu pomáhá jednoduchá fronta. Když je plná, nesmí nový přírůstek přepsat starší práci. Stejný pořádek se hodí i pro čísla zásilek, takže Jo nechce řešit každý druh obsahu zvlášť.

</details>
<!-- aiva-story:end -->

Jo March může redaktorce odložit nejvýše dva rukopisy. Nový nesmí přepsat starší, odebrání má uvolnit místo a stejná struktura má fungovat i s čísly zásilek.

## Tvůj zásah

Doplň typově bezpečnou frontu Slots<T> pomocí dvou polí typu T. Nevyužívej konkrétní String ani přetypování.

## Připravené okolí

Main je připravený klient pro dva různé typy. Null při take znamená prázdnou frontu; protože add null odmítá, není tato odpověď nejednoznačná. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Slots<T> má kapacitu 2. add(T) odmítne null i plnou frontu bez změny; jinak přidá na konec. take vrací nejstarší hodnotu a odebere ji, při prázdné frontě vrátí null. Vstup: počet akcí 0–20 a ADD název / TAKE, názvy jsou slova. Main předem zkusí null a nakonec tutéž třídu ověří i s Integer. Po každé akci vypíše výsledek a size.

Ukázkový vstup:

```text
5 ADD A ADD B ADD C TAKE TAKE
```

Očekávaný výstup:

```text
Null: false
Pridano: true
Pocet: 1
Pridano: true
Pocet: 2
Pridano: false
Pocet: 2
Odebrano: A
Pocet: 1
Odebrano: B
Pocet: 0
Cisla: 7,8
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
