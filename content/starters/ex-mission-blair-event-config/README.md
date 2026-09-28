# Blair opravuje konfiguraci před otevřením dveří

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Gossip Girl**

Před otevřením sálu Blair kontroluje poslední nastavení akce. Serena změnila připomínky a někdo další upravil kapacitu. Program přijme konfiguraci bez protestu, jen se výsledné chování začne rozcházet s tím, co organizátorky chtěly.

Jedna hodnota je text místo skutečné volby ano/ne, jiná sice vypadá jako správné číslo, ale pro sál nedává smysl. Blair chce potíže vidět ještě před příchodem hostů. Zmatky u šatny jsou dostatečně napínavé i bez přispění konfigurace.

</details>
<!-- aiva-story:end -->

Připomínky se vypnuly, přestože někdo do konfigurace napsal "false" jako text. Jinde prošla nulová kapacita. Pomoz aplikaci odmítnout nejednoznačné nastavení ještě před začátkem akce.

## Tvůj úkol

Oprav označený `EventConfig.read`. Připravený parser vrací Object. Vyžaduj mapu, capacity jako Integer 1–200, reminders jako Boolean a host jako neprázdný String po trimu. Řetězce na čísla ani booleany nepřeváděj. Neznámé klíče ignoruj; chybějící a nesprávné hodnoty odmítni IllegalArgumentException. Parser ponech: syntaxe a duplicitní klíče mají dál vyhazovat YAMLException. Z kořene tohoto samostatného projektu spusť `mvn test` s JDK 21 nebo novějším a Mavenem. Při prvním běhu Maven může stáhnout závislosti. Výsledek a počet testů zkontroluj v `target/surefire-reports`. Všech 5 testů musí projít. Přidej vlastní případ `host: null`.

## Připravené okolí

SnakeYAML parser už je nastavený a testy jsou připravené. Zkontroluj typy hodnot, které parser vrací, a doplň ověření povolených rozsahů.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Ověření dokonči podle konkrétních bodů níže.

## Kontrola

- [ ] Textové "40" a "false" jsou odmítnuté, správné typy fungují.
- [ ] Kapacity 1 a 200 projdou; 0, 201 a desetinná hodnota ne.
- [ ] Duplicate-key ochrana parseru zůstává zapnutá.
- [ ] Pět testů a vlastní null případ projde.
