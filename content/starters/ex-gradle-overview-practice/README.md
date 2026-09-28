# U Ley to musí fungovat taky

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Nela a Lea chtějí společně upravovat e-shop. Jedné projdou kontroly dopravy, druhé se sestavení zastaví ještě před nimi. Když sjednotí verzi nástroje, objeví se další nepříjemná otázka: spouštějí se testy vůbec?

Zelený výsledek je uklidňuje jen do chvíle, než si všimnou chybějící kontroly. Potřebují opakovatelný postup pro obě zařízení a důkaz, že zahrnuje skutečné testy. Pak mohou řešit nové funkce bez hádání, co která instalace právě udělala.

</details>
<!-- aiva-story:end -->

Nele projdou testy e-shopu, Lea má ale jinou verzi Gradlu. Pomoz týmu spouštět sestavení stejným nástrojem a ověř, že zelený výsledek opravdu zahrnuje test dopravy.

Ve starteru s `build.gradle.kts` vytvoř wrapper pro verzi `8.14.3` pomocí instalovaného Gradlu. Použij JDK 21. Potom spusť přes wrapper `test` a `build`; na Windows použij `gradlew.bat`, na macOS/Linux `./gradlew`.

Najdi HTML report a otevři výsledek `ShippingTest`. Do poznámky pro Leu uveď příkazy i cestu k reportu. První stažení nástroje a knihoven potřebuje internet.

## Spuštění

Použij JDK 21 a Gradle 8.14.3. Vytvoř wrapper příkazem `gradle wrapper --gradle-version 8.14.3`, pak spusť `./gradlew test` (Windows: `gradlew.bat test`).

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Wrapper soubory existují a build používá jejich verzi.
- Test report obsahuje ShippingTest.
- Odlišuji build a zdrojové soubory.
