# Jill potřebuje stejný výsledek na druhém počítači

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Resident Evil**

Jill předává Claire program pro přehled evakuačních zásob. Na vlastním notebooku ho používala celý den, druhý počítač ale odmítá jednu část Java kódu. Po změně nastavení sice sestavení projde, jenže podezřele rychle.

Ukáže se, že kontroly se vůbec nespustily. Claire potřebuje převzít nástroj, kterému může věřit i mimo Jillin počítač. Součástí předání proto musí být shodný způsob sestavení a ověření, že se připravené testy opravdu spustily.

</details>
<!-- aiva-story:end -->

Jill předává výpočet zásob Claire. Jednomu počítači vadí record, na druhém build „projde“, přestože nespustí testy. Pomoz opravit konfiguraci a přibalit opakovatelný způsob sestavení.

## Tvůj úkol

V tomto odděleném Gradle projektu oprav pouze `build.gradle.kts`: zdroje jsou pro Java 21 a oba JUnit testy se musí opravdu spustit. Neodstraňuj record ani testy. Použij JDK 21 a Gradle 8.14.3; první běh může stahovat závislosti. Po opravě spusť `gradle test` a v `build/test-results/test` ověř 2 testy. Potom vytvoř wrapper `gradle wrapper --gradle-version 8.14.3` a spusť `./gradlew clean test` (Windows `gradlew.bat clean test`). Připrav k předání gradlew, gradlew.bat a celý gradle/wrapper, včetně JAR. Výstupy build a cache .gradle do předání nepatří. Nakonec zkus v testu chybnou očekávanou hodnotu: wrapper musí selhat; po vrácení opravy projde.

## Připravené okolí

Výpočet zásob a dva testy jsou hotové. Kotlin DSL zde jen konfiguruje nástroje; aplikace je pořád Java. Wrapper se generuje nástrojem, jeho JAR nepíšeš ručně.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Ověření dokonči podle konkrétních bodů níže.

## Kontrola

- [ ] Projekt se překládá pro Java 21 bez změn aplikačního kódu.
- [ ] Report obsahuje oba testy a žádný není přeskočený.
- [ ] Wrapper je vygenerovaný pro 8.14.3 a clean test přes něj projde.
- [ ] Záměrně vadná assertion způsobí selhání, po jejím vrácení testy projdou.
- [ ] Předání obsahuje všechny wrapper soubory, ale ne build ani .gradle.
