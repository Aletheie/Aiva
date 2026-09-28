# Na festival se hlásí někdo ve věku „ahoj“

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Na zkušební festivalovou registraci dorazily tři podivné odpovědi: jeden neuvěřitelný věk, jeden záporný a jeden přátelský pozdrav. Nela alespoň ví, že kamarádky její prosbu o testování vzaly vážně.

Teď chce, aby formulář rozlišil špatně napsané číslo od čísla, které se pro registraci nedá použít. Program nesmí po první chybě prostě zmizet. Ema čeká na opravu a už má připravenou další várku údajů, kterým se u ostrého vstupu bude lepší vyhnout.

</details>
<!-- aiva-story:end -->

Nele do festivalové registrace přistály věky `131`, `-1` a `ahoj`. Pomoz rozlišit překlep v čísle od čísla mimo povolený rozsah, aby každá chyba dostala užitečnou zprávu.

Uprav `readAge`, aby přijímala pouze 0–130 včetně. Nečíselný text má dál vlastní zprávu. Ověř vstupy `0`, `130`, `131`, `-1` a `ahoj`; po každém se musí provést `finally`.

Před spuštěním si ke každému vstupu napiš: platný věk, chybný rozsah, nebo nečíselný text. Samotné „něco se pokazilo“ registraci neopraví.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Obě hranice jsou platné.
- Rozsah a formát mají odlišné zprávy.
- Každý pokus provede finally.
