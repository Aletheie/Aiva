# Spencer kontroluje typy údajů v JSON

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pretty Little Liars**

Spencer sjednocuje poznámky, které si parta posílala během pátrání po „A“. Každá stopa má označení a údaj o tom, jak moc je ověřená. Aria přinese nový export, který na první pohled projde bez chyby.

Při bližším čtení se však z chybějící informace stává konkrétní číslo a některá označení změnila typ. Spencer nechce, aby program vyplňoval mezery v důkazech vlastní fantazií. Než data přijme, potřebuje poznat, zda záznam skutečně obsahuje to, co o sobě tvrdí.

</details>
<!-- aiva-story:end -->

Spencer dostala export poznámek. JSON se někdy načte, ale z chybějící důvěryhodnosti vznikne nula a z čísla se stane textové ID. Ověř, že každý načtený záznam obsahuje povinné údaje se správnými typy.

## Tvůj úkol

Oprav označenou část `EvidenceReader.java`. Kořen musí být objekt. `id` a `label` musí být skutečné JSON řetězce, po trim neprázdné; úvodní nuly zachovej. `confidence` musí být JSON číslo s celočíselnou hodnotou 0–100, bez přetečení; řetězec "80" není číslo. Neznámé klíče ignoruj. Neplatnou syntaxi i data odmítni jako IllegalArgumentException. Z kořene tohoto samostatného projektu spusť `mvn test` s JDK 21 nebo novějším a Mavenem. Při prvním běhu Maven může stáhnout závislosti. Výsledek a počet testů zkontroluj v `target/surefire-reports`. Připravených 5 testů neměň. Přidej vlastní případ prázdného ID a vysvětli, proč pouhé fromJson do recordu pravidla nezaručí.

## Připravené okolí

Maven, Gson a JUnit jsou připravené. V řešení můžeš použít JsonElement/JsonObject; potřebné operace najdeš v lekci. Větší čísla můžeš přes BigDecimal.intValueExact ověřit přesně. Tuto pomocnou operaci nemusíš implementovat.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Ověření dokonči podle konkrétních bodů níže.

## Kontrola

- [ ] Pět dodaných testů a vlastní test projde.
- [ ] 007 zůstane 007 a UTF-8 jméno se neztratí.
- [ ] Chybějící, null a špatně typované hodnoty neprojdou jako výchozí hodnoty.
- [ ] Desetinné hodnoty ani čísla mimo int se tiše neoříznou.
