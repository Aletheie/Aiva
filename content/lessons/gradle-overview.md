## Stejný cíl jako Maven, jiný zápis

Aby šel spustit test ceny dopravy, musí se nejdřív přeložit třída `Shipping` a potom samotný test. **Gradle** takové kroky zapisuje jako **úlohy (tasks)**, které na sobě závisejí. Když vyžádáš `build`, vybere potřebné předchozí úlohy a provede je ve správném pořadí. Podobně jako [Maven](lesson:maven-overview) obstarává také knihovny a balení výsledku.

V projektu zvol jeden hlavní build. Dva nezávislé soubory `pom.xml` a `build.gradle.kts` se samy nesynchronizují. Tuto lekci zkoušej v oddělené složce, například kopii malého projektu Shipping bez jeho `target` a `pom.xml`.

## Kotlin DSL krok za krokem

Gradle umí konfigurační zápis Groovy (`build.gradle`) i Kotlin (`build.gradle.kts`). Konfigurace níže je Kotlin DSL, jazyk pro popis sestavení. Aplikační zdroje přitom dál píšeš v Javě. Do `settings.gradle.kts` patří:

```kotlin
rootProject.name = "shipping-course"
```

`rootProject.name` určuje název hlavního projektu. Soubor `build.gradle.kts` obsahuje:

```kotlin
plugins {
    java
}

group = "cz.kurz"
version = "1.0.0"

repositories {
    mavenCentral()
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

dependencies {
    implementation("com.google.code.gson:gson:2.13.1")
    testImplementation(platform("org.junit:junit-bom:5.12.2"))
    testImplementation("org.junit.jupiter:junit-jupiter")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.test {
    useJUnitPlatform()
}
```

`plugins { java }` zapne Java podporu, standardní adresáře a úlohy. `group` a `version` určují identitu vydání. `repositories { mavenCentral() }` říká, odkud brát knihovny; Maven Central je veřejný repozitář artefaktů, nikoli tvůj Git repozitář.

`toolchain` vybírá JDK pro překlad a testy. `JavaLanguageVersion.of(21)` vyjadřuje Java 21. Pokud takové JDK není dostupné a nemáš nastavené jeho automatické stažení, Gradle může skončit chybou; nainstaluj a nastav odpovídající JDK. JDK potřebné pro spuštění samotného Gradlu se navíc řídí podporovanou verzí Gradlu. Příklady předpokládají Gradle 8.14.x a JDK 21.

## Co znamenají závislosti

`implementation(...)` přidává knihovnu pro kód aplikace. Řetězec obsahuje stejnou trojici `group:artifact:version` jako Maven. `testImplementation` ji přidává jen pro testy. `platform("org.junit:junit-bom:5.12.2")` načte **BOM**, sadu vzájemně sladěných verzí; proto další dvě JUnit závislosti nemají vlastní verzi. `testRuntimeOnly` přidává spouštěč potřebný při běhu testů.

`tasks.test` konfiguruje testovací úlohu. `useJUnitPlatform()` vybírá platformu pro testy Jupiter; samotný import anotace `@Test` tuto konfiguraci nenahrazuje.

## Wrapper a praktické příkazy

Používej **Gradle Wrapper**, malé spouštěcí soubory `gradlew`, `gradlew.bat` a adresář `gradle/wrapper`. Wrapper zajistí projektovou verzi Gradlu bez nutnosti shodné globální instalace. Při první přípravě ho vytvoří instalovaný Gradle příkazem `gradle wrapper --gradle-version 8.14.3`. `--gradle-version` určuje verzi, kterou bude wrapper stahovat. Wrapper soubory ulož do Gitu; první spuštění obvykle potřebuje internet.

| macOS / Linux | Windows | Význam |
|---|---|---|
| `./gradlew tasks` | `gradlew.bat tasks` | Dostupné úlohy |
| `./gradlew test` | `gradlew.bat test` | Překlad a spuštění testů |
| `./gradlew build` | `gradlew.bat build` | Ověření i vytvoření balíčku |
| `./gradlew clean` | `gradlew.bat clean` | Smazání vygenerovaného výstupu |
| `./gradlew dependencies` | `gradlew.bat dependencies` | Strom závislostí |

`./` znamená skript v aktuální složce. Výstup vzniká v `build`, testový HTML report v `build/reports/tests/test/index.html`. Java zdroje zůstávají v `src/main/java`, testy v `src/test/java`, takže lze přenést `Shipping` a `ShippingTest` z [JUnit lekce](lesson:testing-overview).

## Jak ověřit, že testy skutečně běží

Spusť testy, ověř počet nalezených testů a zkus úmyslně špatné očekávání. Build má zčervenat, pak opravu vrať. Úspěšný příkaz s nulovým počtem testů není důkaz správnosti programu.

Gradle může využívat výsledky nezměněných úloh z minulého běhu. To neznamená přeskočení nutné práce; rozhoduje podle vstupů a výstupů. Pro tento projekt ti stačí uvedené nastavení a wrapper. Ověř hlavně, že spolužačka dokáže stejným příkazem spustit stejné testy ve své kopii projektu.
