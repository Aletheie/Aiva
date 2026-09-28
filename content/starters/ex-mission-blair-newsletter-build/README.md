# Blair opravuje sestavení pozvánky

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Gossip Girl**

Blair schválila podobu pozvánky v Danově editoru a považuje technickou část za hotovou. Serena si stáhne čistý projekt, spustí sestavení a místo náhledu dostane chybu chybějící knihovny. Večírek zatím existuje nejspolehlivěji na papíře.

Po první úpravě build zezelená nezvykle rychle. Blair už by rozesílala pozvánky, Dan si ale všimne, že se neprovedly testy. Potřebují projekt, který má všechny závislosti a opravdu ověřuje výsledek, jinak se problém jen přesune k další organizátorce.

</details>
<!-- aiva-story:end -->

Náhled pozvánky fungoval v cizím editoru, ale čistý projekt nenajde Gson. Po první opravě sestavení projde, ale nespustí testy. Doplň konfiguraci tak, aby se projekt přeložil i otestoval.

## Tvůj úkol

Oprav pouze `pom.xml`: Gson používá produkční Newsletter, proto musí být dostupný při překladu i běhu aplikace. JUnit ponech jen pro testy. Odstraň nastavení, které testy přeskakuje; zachovej verze knihoven, release 21 a připravené pluginy. Z kořene tohoto samostatného projektu spusť `mvn test` s JDK 21 nebo novějším a Mavenem. Při prvním běhu Maven může stáhnout závislosti. Výsledek a počet testů zkontroluj v `target/surefire-reports`. Musí opravdu proběhnout všechny 3 testy. Potom v testu dočasně změň očekávaný nadpis na chybný: další běh musí selhat. Změnu testu vrať a testy spusť znovu.

## Připravené okolí

Newsletter a tři testy jsou hotové. Jejich syntaxi nemusíš dopisovat; porovnáváš, kam závislost patří a jestli ji build skutečně použil.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Ověření dokonči podle konkrétních bodů níže.

## Kontrola

- [ ] Čistý projekt se přeloží bez ručního přidávání JAR do IDEA.
- [ ] V reportu proběhly 3 testy, žádný není přeskočený.
- [ ] Úmyslně chybná assertion způsobila neúspěšný build; po vrácení je build zelený.
- [ ] JUnit zůstává ve scope test a Gson je produkční závislost.
