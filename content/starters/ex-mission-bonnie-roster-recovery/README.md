# Bonnie nechce přijít o hosty kvůli jednomu souboru

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Upíří deníky**

Bonnie pomáhá Caroline s přehledem hostů penzionu v Mystic Falls. Starý seznam sedí a je potřeba k němu načíst novější export. Uprostřed souboru se ovšem objeví poškozený záznam.

Aplikace už před chybou odstranila původní data a teď nechává jen kus nového seznamu. Caroline se ptá, komu vlastně připravit pokoje. Bonnie potřebuje mít vždy celý použitelný přehled; nepovedený import nemá rozbít poslední verzi, podle které se ještě dalo normálně pracovat.

</details>
<!-- aiva-story:end -->

Bonnie načítá seznam hostů penzionu. Poškozený export nyní smaže poslední použitelný seznam, někdy dokonce nechá jen jeho první položku. Pomoz jí bezpečně rozhodnout, zda se nový soubor dá přijmout celý.

## Tvůj úkol

Oprav jen `GuestRoster.load(Path)`. Přijmi JSON pole skutečných řetězců: trimuj jména, odmítni prázdná a duplicity po trimu; velikost písmen rozlišuj. Prázdné pole je platné a seznam vyprázdní. Celý platný soubor nahradí stav a vrací true. Chybějící soubor, rozbitá syntaxe i jediná vadná položka vrací false a zachová poslední úspěšný stav beze změny. Z kořene tohoto samostatného projektu spusť `mvn test` s JDK 21 nebo novějším a Mavenem. Při prvním běhu Maven může stáhnout závislosti. Výsledek a počet testů zkontroluj v `target/surefire-reports`. Pět testů používá vlastní dočasné soubory; přidej test dobrý import → chybný import → další dobrý import.

## Připravené okolí

Metoda snapshot a dočasné složky pro testy už jsou připravené. Testy nečtou osobní soubory. Měníš pořadí práce se stavem a validaci, nikoli testovací infrastrukturu.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Ověření dokonči podle konkrétních bodů níže.

## Kontrola

- [ ] Při chybě u druhé položky zůstane původní seznam beze změny.
- [ ] Po neúspěchu zůstává poslední úspěšný stav, nejen výchozí Elena.
- [ ] [] uspěje, zatímco null, objekt a duplicitní jména ne.
- [ ] Pět testů a vlastní sekvence importů projde.
