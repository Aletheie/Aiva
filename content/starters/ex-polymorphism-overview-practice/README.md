# Herní průvodce se umí i rozloučit

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

Herní průvodce vítá nové hráče, připomíná jim úkol a nadšeně reaguje na jejich kroky. Jakmile však někdo ukončí výpravu, hra beze slova zmizí. Ema tvrdí, že i podivná lesní bytost by se uměla rozloučit zdvořileji.

Lea proto přidá nový druh zprávy. Nechce kvůli každé větě přepisovat společný výpis; ten už přece dokáže zprávy požádat o jejich vlastní text. Na rozloučení si vyzkouší, zda lze přidat nový druh zprávy beze změny společného výpisu.

</details>
<!-- aiva-story:end -->

Tvůj herní průvodce hráče přivítá a připomene jim další krok. Když odejdou, zůstane trapné ticho. Doplň rozloučení, aniž by výpis musel zkoumat každý druh zprávy.

Přidej `Goodbye extends Message` s `text()` vracející `Na shledanou`. Vlož objekt do pole `messages` a nech tělo `for-each` beze změny.

Ověř původní zprávy i nové rozloučení. Pak vlastními slovy vysvětli, proč cyklus nepotřebuje `instanceof` ani další větev `if`.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Nová zpráva se vypíše přes původní cyklus.
- Řešení nemá větvení podle typu.
- Rozliším typ reference a skutečný objekt.
