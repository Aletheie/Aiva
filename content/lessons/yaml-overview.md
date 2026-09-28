## Konfigurace čitelná pro člověka

Název klubu nebo seznam jeho témat můžeš chtít upravit bez přepisování Java kódu. Takové nastavení uložíme do textového souboru **YAML**. Přípony `.yaml` a `.yml` označují stejný formát. Příslušnost položek vyjadřuje odsazením a dovoluje komentáře začínající `#`.

```yaml
name: "Java klub"
port: 8080
enabled: true
topics:
  - java
  - oop
```

`name: hodnota` je dvojice klíč–hodnota, `topics` obsahuje seznam označený pomlčkami. Odsazení piš konzistentně mezerami, ne tabulátory. Číslo `8080` a text `"8080"` nejsou totéž. Pro texty připomínající datum, číslo nebo logickou hodnotu používej uvozovky, aby nebyl jejich typ překvapivě odvozen. Příklady knihovny níže používají pravidla YAML 1.1, v nichž například neuzavřené `yes` může být boolean.

## Závislost a úplný příklad

Do `<dependencies>` projektu z [Mavenu](lesson:maven-overview) přidej:

```xml
<dependency>
  <groupId>org.yaml</groupId>
  <artifactId>snakeyaml</artifactId>
  <version>2.4</version>
</dependency>
```

SnakeYAML je parser i zapisovač YAML; verze je zde připnutá pro příklad. Do `Main.java` vlož následující program. Vstup vytváříme přímo jako text, takže nepotřebuje předem existující soubor.

```java
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.LinkedHashMap;
import java.util.Map;
import org.yaml.snakeyaml.LoaderOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.SafeConstructor;

public class Main {
    public static void main(String[] args) throws IOException {
        LoaderOptions options = new LoaderOptions();
        options.setAllowDuplicateKeys(false);
        options.setMaxAliasesForCollections(20);
        options.setCodePointLimit(100_000);
        Yaml yaml = new Yaml(new SafeConstructor(options));

        Object loaded = yaml.load("name: Java klub\nport: 8080\n");
        if (!(loaded instanceof Map<?, ?> values)) {
            throw new IllegalArgumentException("Konfigurace musí být mapa");
        }
        if (!(values.get("name") instanceof String name) || name.isBlank()) {
            throw new IllegalArgumentException("Chybí textové jméno");
        }
        if (!(values.get("port") instanceof Integer port) || port < 1 || port > 65535) {
            throw new IllegalArgumentException("Port musí být celé číslo 1–65535");
        }
        System.out.println(name + ": " + port); // Java klub: 8080

        Map<String, Object> saved = new LinkedHashMap<>();
        saved.put("name", name);
        saved.put("port", port);
        Files.writeString(Path.of("config.yaml"), yaml.dump(saved), StandardCharsets.UTF_8);
    }
}
```

`LoaderOptions` nastavuje čtení. `setAllowDuplicateKeys(false)` odmítne dvakrát uvedený stejný klíč. `setMaxAliasesForCollections(20)` omezí počet aliasů kolekcí, tedy odkazů na dříve označené části dokumentu. `setCodePointLimit(100_000)` omezí rozsah vstupu v Unicode kódových bodech; podtržítko v čísle jen zlepšuje čitelnost.

`SafeConstructor` vytváří standardní datové typy, nikoli libovolné aplikační objekty podle jmen tříd ve vstupu. `new Yaml(...)` sestaví převodník. `load(text)` vrátí načtená data a `dump(objekt)` vytvoří YAML text. `LinkedHashMap` v ukázce zachová pořadí vložených klíčů. Načítání do obecných typů nás ale nezbavuje kontroly dat.

## Ověř strukturu dřív než přetypuješ

Výsledek může být mapa, seznam, skalár (jednotlivá hodnota), nebo `null` pro prázdný dokument. `instanceof Map<?, ?> values` ověří mapu s dosud neznámými typy klíčů a hodnot. Následná kontrola `instanceof String name` zpřístupní text jen po ověření typu. U `port` navíc kontrolujeme rozsah. Výrazy s `||` skončí hned při první pravdivé části, takže s nesprávným typem už neprovádíme číselné porovnání.

Formát tedy může být platný YAML, a přesto neplatná konfigurace, například `port: "ahoj"`. Parser umí přečíst `port: 0`, ale teprve naše kontrola rozhodne, že pro tuto konfiguraci je nula nepovolená. Chyby syntaxe a limitů knihovna hlásí přes `YAMLException` z balíčku `org.yaml.snakeyaml.error`; při zpracování cizího souboru ji zachyť vedle vlastních validačních chyb a odmítni celé neplatné nastavení.

## Konfigurace ze souboru

Pro skutečný vstup nahraď řádek `yaml.load(...)` za `yaml.load(Files.readString(Path.of("config.yaml"), StandardCharsets.UTF_8))`. `readString` znáš ze [souborů](lesson:files-overview). Následný zápis vynech, pokud chceš jen načítat konfiguraci. Ukázka sice omezuje práci parseru, ale `readString` nejdřív načítá celý soubor; v tomto cvičení používej malé lokální soubory.

Vyzkoušej port 0, textový port a opakované `name`. Každé selhání má jiný důvod: rozsah, typ a duplicitní klíč. Hesla a přístupové klíče do ukázkového souboru nepatří; při [týmové spolupráci](lesson:collaboration-overview) oddělíme příklad konfigurace od místních údajů.
