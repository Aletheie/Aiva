# Ať se Nelině pokladně chyba nevrátí

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Po opravě dopravy má Nela konečně klidnější pokladnu. Pak přidá jinou slevu a Lea si při nákupu všimne, že starý problém je zpátky. Přesná hranice ceny se mezi úpravami znovu posunula.

Nela nechce při každé změně ručně zkoušet všechny objednávky. Potřebuje sadu kontrol, která si zapamatuje běžné situace i rozdíl jediné koruny. Další zkušební nákup by pak měla provést aplikace dřív než skutečná zákaznice.

</details>
<!-- aiva-story:end -->

Nela už opravila dopravu zdarma, ale při další úpravě e-shopu se může stejná chyba vrátit. Pomoz jí postavit testy, které si všimnou i rozdílu jediné koruny.

Do `ShippingTest` přidej parametrizovaný test pro částky `0`, `999`, `1000` a `1001`. Očekávej postupně `79`, `79`, `0`, `0` a spusť `mvn test`. Přidej také odmítnutí `-1` přes `assertThrows`, pokud ve starteru ještě není.

Teď testy prověř: dočasně změň `>=` na `>`. Případ pro přesně 1000 Kč musí selhat. Vrať opravu a spusť testy znovu — úkol končí až se zeleným výsledkem.

## Spuštění

Použij Maven projekt s JDK 21+. V kořeni s pom.xml spusť `mvn test`, případně testy spusť v IDE. AIVA zde používá checklist, nikoli automatický JUnit judge.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Čtyři hraniční případy skutečně běží.
- Test zachytí úmyslnou chybu operátoru.
- Test záporného vstupu používá assertThrows.
