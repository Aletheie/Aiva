# Klubový bot zdraví cizím jménem

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Klubový bot se měl naučit vítat nové hosty. Při další zkoušce však osloví každou návštěvnici stejným cizím jménem. Ema si nejdřív myslí, že si Lea dělá legraci; pak se podívají, jaké údaje bot skutečně vyhledává.

Nestačí přidat náhradní oslovení, pokud program pořád hledá tutéž osobu. Test potřebuje rozlišit známého člověka od neznámého a poznat i záměnu identifikátoru.

</details>
<!-- aiva-story:end -->

Klubový bot má nového návštěvníka přivítat jako hosta. Jenže když omylem hledá pořád stejné ID, osloví ho jménem někoho jiného. Pomoz napsat test, který odhalí obě části problému.

Do `GreetingServiceTest` přidej případ pro ID `99`, na které repository odpoví `null`. Očekávej `Ahoj, hoste` a právě jedno hledání ID `99`. Spusť `mvn test`.

Pak krátce změň službu na hledání pevného ID `7` a ověř, že test chybu zachytí. Nakonec vrať skutečný parametr a spusť oba scénáře, pro známého i neznámého člověka.

## Spuštění

V kořeni s pom.xml spusť `mvn test`. Starter obsahuje rozhraní, službu a první test. Mockito používá náhrady rozhraní přes mock-maker-proxy bez připojování JVM agenta.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Test známého i neznámého uživatele běží.
- Záměrná chyba pevného ID je zachycena.
- Umím rozlišit unit test s mockem od integračního testu úložiště.
