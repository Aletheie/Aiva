# Sally nechce, aby po večeři zmizel jediný cent

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Když Harry potkal Sally**

Sally už má výpočet pro dělení společného účtu a Harry slavnostně oznámí, že všechny testy prošly. Sally zkusí výpočet úmyslně pokazit. Testy projdou znovu. Harry uzná, že jejich optimismus je možná příliš odolný.

Skupina potřebuje zaplatit přesně celou částku a rozdělit ji férově i tehdy, když nevychází stejné podíly. Sally chce kontroly, které tyto vlastnosti opravdu hlídají.

</details>
<!-- aiva-story:end -->

Sally z Když Harry potkal Sally dělí účet skupině přátel. Výpočet je připravený, ale dosavadní test projde i po úplném rozbití aplikace. Napiš testy, které ověří součet plateb i rozdělení zbytku.

## Tvůj úkol

Pracuj v `src/test/java/BillSplitTest.java`; produkční BillSplit je správný. Účet je celé nezáporné číslo centů, skupina má 1–12 lidí. Každý dostane celočíselný podíl a zbylé centy po jednom první lidé: 101/3 → [34,34,33]. Otestuj dělitelnost, zbytek, méně centů než lidí, nulu, jednoho člověka i neplatné vstupy. Z kořene tohoto samostatného projektu spusť `mvn test` s JDK 21 nebo novějším a Mavenem. Při prvním běhu Maven může stáhnout závislosti. Výsledek a počet testů zkontroluj v `target/surefire-reports`. Potom si zálohuj BillSplit.java a postupně do něj vlož obsah každého ze tří souborů `variants/*.java.txt`. Pro každou chybnou variantu musí alespoň jeden test selhat kvůli chování. Po každém pokusu vrať správný zdroj; závěr má být zelený. Varianty jsou celé zdrojové soubory a do src se nekopírují pod příponou .txt.

## Připravené okolí

Produkční výpočet, Maven a tři záměrně chybné varianty jsou připravené. Cílem je navrhnout scénáře a assertions, ne znovu implementovat dělení účtu.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Ověření dokonči podle konkrétních bodů níže.

## Kontrola

- [ ] Správná implementace projde všemi napsanými testy.
- [ ] Variantu drop-remainder odhalí nedělitelné rozdělení.
- [ ] Variantu wrong-order odhalí pořadí přidělených centů, ne jen součet.
- [ ] Variantu no-max-group odhalí 13 účastníků.
- [ ] Po experimentech je vrácený původní BillSplit a testy zůstávají.
