## Opakovatelný postup sestavení

Pošleš projekt spolužačce a chceš, aby ho sestavila se stejnými knihovnami jako ty. Místo seznamu ručních kroků je zapíšeš do nastavení projektu. Maven je **nástroj pro sestavení (build tool)**: stáhne potřebné knihovny, přeloží kód, spustí testy a připraví balíček. Používané knihovně říkáme **závislost (dependency)**. Její název a verzi najde Maven v `pom.xml`.

Maven není Java ani IDE. Potřebuje JDK a příkaz `mvn`; dostupnost ověříš `mvn --version`. IDE může mít Maven přibalený, zatímco v terminálu ještě dostupný není. JDK zobrazené tímto příkazem porovnej s JDK projektu. Kurz používá jazykovou úroveň Java 21 bez preview funkcí.

## Struktura malého projektu

```text
hello-course/
  pom.xml
  src/main/java/Main.java
  src/main/resources/
  src/test/java/
  target/
```

`src/main/java` obsahuje produkční kód, `src/test/java` testy, `src/main/resources` přibalená data. `target` vzniká sestavením a nemá být ručně upravovaným zdrojem. V terminálu pracuj ve složce obsahující `pom.xml`.

Následující kompletní `pom.xml` je XML dokument. Značka `<version>...</version>` obklopuje hodnotu; odpovídající uzavírací značka má lomítko. Atribut `xmlns` určuje jmenný prostor formátu POM, nic se tím při zápisu nestahuje.

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0">
  <modelVersion>4.0.0</modelVersion>
  <groupId>cz.kurz</groupId>
  <artifactId>hello-course</artifactId>
  <version>1.0.0</version>
  <properties>
    <maven.compiler.release>21</maven.compiler.release>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
  </properties>
  <dependencies>
    <dependency>
      <groupId>com.google.code.gson</groupId>
      <artifactId>gson</artifactId>
      <version>2.13.1</version>
    </dependency>
    <dependency>
      <groupId>org.junit.jupiter</groupId>
      <artifactId>junit-jupiter</artifactId>
      <version>5.12.2</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
  <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.14.0</version>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-surefire-plugin</artifactId>
        <version>3.5.3</version>
      </plugin>
    </plugins>
  </build>
</project>
```

`modelVersion` je verze formátu POM, nikoli Javy. Trojice `groupId`, `artifactId`, `version` určuje konkrétní knihovnu a její vydání. Například `com.google.code.gson`, `gson`, `2.13.1` označuje Gson ve verzi použité v tomto kurzu. Pevně uvedená verze pomáhá, aby obě spolužačky pracovaly se stejným vydáním.

`maven.compiler.release` nastaví jazyk i dostupné standardní API pro Java 21. `project.build.sourceEncoding` určuje kódování zdrojů. Gson použijeme pro [JSON](lesson:json-overview); JUnit pro [testy](lesson:testing-overview). Vynechaný `scope` znamená běžný rozsah `compile`. `test` zpřístupní JUnit testům, ale nepřidává ho jako běžnou runtime závislost aplikace. Rozsah `runtime` je pro knihovny potřebné při běhu, `provided` pro knihovny dodané cílovým prostředím.

**Plugin** provádí build operaci; není totéž co knihovna volaná z aplikace. Compiler plugin překládá kód, Surefire spouští jednotkové testy. Závislosti knihoven na dalších knihovnách jsou **tranzitivní**; nemusíš je všechny ručně vypisovat.

## První sestavení krok za krokem

Do `src/main/java/Main.java` vlož:

```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Sestaveno Mavenem");
    }
}
```

Spusť `mvn compile`, pak `java -cp target/classes Main`. `-cp` nastavuje classpath, tedy místa, kde Java hledá přeložené třídy a knihovny. Tento program žádnou externí knihovnu nevolá, takže uvedená cesta stačí. Gson program spouštěj konfigurací IDE s Maven závislostmi, nebo sestaveným balíčkem se závislostmi; samotná cesta `target/classes` je nenajde.

| Příkaz | Co provede |
|---|---|
| `mvn compile` | Přeloží hlavní zdroje a potřebné předchozí fáze |
| `mvn test` | Navíc přeloží a spustí jednotkové testy |
| `mvn package` | Provede předchozí fáze včetně testů a vytvoří balíček |
| `mvn clean` | Odstraní vygenerovaný `target` |
| `mvn clean test` | Smaže starý výstup a znovu sestaví i otestuje |
| `mvn dependency:tree` | Ukáže strom přímých a tranzitivních závislostí |

Posloupnosti fází se říká **životní cyklus (lifecycle)**. `dependency:tree` je naproti tomu konkrétní cíl pluginu. První stažení závislostí vyžaduje internet, další sestavení může využít lokální cache. Otevření této offline lekce žádné knihovny nestahuje.

## JAR není automaticky spustitelná aplikace

`mvn package` běžně vytvoří JAR, archiv přeložených tříd a prostředků. Sám neurčuje hlavní třídu ani dovnitř automaticky nekopíruje všechny závislosti. Projekt StudyDesk používá Shade plugin, který závislosti zabalí a nastaví vstupní třídu. Zatím odlišuj úspěšné sestavení od správného příkazu ke spuštění.

Zkus přejmenovat třídu bez změny jména souboru: build má selhat s chybou překladače. Oprav ji a spusť znovu. Pokud Maven nenajde závislost, kontroluj souřadnice, připojení a repozitář; změna Java syntaxe takový problém neřeší.
