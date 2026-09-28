# Klubová aplikace nechce nastartovat

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Java klub chystá herní večer a každá organizátorka upravila v konfiguraci něco jiného. Ema název místnosti, Lea připojení, Nela počet míst. Soubor se po společných změnách tváří skoro stejně jako předtím, jen aplikace odmítá nastartovat.

Při prohlížení se objeví několik odlišných problémů. Něco se nedá přečíst, něco má nesprávný typ a něco nedává smysl až podle pravidel aplikace. Parta potřebuje poznat, co opravovat, aby pouhé odstranění jedné chyby nezakrylo další dvě.

</details>
<!-- aiva-story:end -->

Java klub chystá herní večer, ale konfigurace aplikace se po ruční úpravě nenačte. Pomoz rozlišit tři různé chyby, které na první pohled vypadají jako „něco s YAML“.

V textu předaném do `load` postupně zkus port `0`, port `"8080"` v uvozovkách a dvakrát klíč `name`. U každého pokusu předpověz, zda je špatně rozsah, typ, nebo struktura, a porovnej to s hlášením.

Nakonec vrať platnou mapu a ověř vytvořený `config.yaml`. Cílem je najít příčinu, ne umlčet validaci.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu. Před spuštěním nech IDE načíst Maven závislosti; obyčejný javac bez classpath knihovnu nenajde.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Rozlišuji všechny tři příčiny.
- Platná konfigurace se zapíše.
- Nepoužívám neověřený cast celého výsledku.
