## Textový formát pro strukturovaná data

Ada má v aplikaci 12 bodů. Chceme její profil uložit tak, aby šel po novém spuštění znovu načíst. **JSON (JavaScript Object Notation)** zapíše jméno, body a další údaje do textu. Podporuje objekty, pole, texty, čísla, booleany a `null`. Převod profilu na tento zápis je **serializace (serialization)**; vytvoření hodnot z načteného textu je **deserializace (deserialization)**.

```json
{"name":"Ada","points":12,"active":true,"tags":["java","oop"]}
```

Složené závorky označují objekt s dvojicemi klíč–hodnota, hranaté pole. Klíče i texty mají dvojité uvozovky. Číslo `12` se liší od textu `"12"`. Mezi položkami jsou čárky, za poslední čárka není. Standardní JSON nepovoluje komentáře. Uvozovka uvnitř textu se zapisuje `\"`.

## Převod pomocí Gson

Použij projekt s Gson `2.13.1` z [lekce Maven](lesson:maven-overview). Do `src/main/java/Main.java` patří celý příklad:

```java
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonParseException;
import com.google.gson.Strictness;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

public class Main {
    record Profile(String name, int points) {}

    public static void main(String[] args) {
        Gson gson = new GsonBuilder()
                .setStrictness(Strictness.STRICT)
                .setPrettyPrinting()
                .create();
        Path file = Path.of("profile.json");
        try {
            Profile original = new Profile("Ada", 12);
            String json = gson.toJson(original);
            Files.writeString(file, json, StandardCharsets.UTF_8);
            String saved = Files.readString(file, StandardCharsets.UTF_8);
            Profile loaded = gson.fromJson(saved, Profile.class);
            if (loaded == null || loaded.name() == null
                    || loaded.name().isBlank() || loaded.points() < 0) {
                throw new IllegalArgumentException("Neplatný profil");
            }
            System.out.println(loaded.name() + ": " + loaded.points());
        } catch (IOException error) {
            System.out.println("Soubor: " + error.getMessage());
        } catch (JsonParseException | IllegalArgumentException error) {
            System.out.println("Data: " + error.getMessage());
        }
    }
}
```

Výstup je `Ada: 12`; vznikne také `profile.json`. `record Profile(...)` je malý datový typ s přístupovými metodami `name()` a `points()`, vysvětlený v [zapouzdření](lesson:encapsulation-overview).

`GsonBuilder` postupně nastavuje převodník. `setStrictness(Strictness.STRICT)` zapne striktní čtení syntaxe, `setPrettyPrinting()` hezky odsadí výstup a `create()` vrátí hotový `Gson`. `toJson(objekt)` vrací JSON text. `fromJson(text, Profile.class)` čte text podle cílového typu; zápis `.class` předává informaci o třídě, nevytváří profil.

`Files.writeString` a `readString` znáš ze [souborů](lesson:files-overview). Blok `catch` s `|` zachytí jeden ze dvou nesouvisejících typů výjimek společným tělem. Chyba čtení souboru a neplatná data tak zůstávají rozlišitelné.

## Správně napsaný JSON může obsahovat špatné body

JSON `null` lze úspěšně přečíst, ale profil aplikace očekává objekt. Chybějící textové pole může vyjít jako `null`, chybějící číselné pole jako `0`. Také `{"name":"Ada","points":-5}` je správně napsaný JSON, ale záporné body naše aplikace nepřijímá. Proto po převodu kontrolujeme i samotné hodnoty. Gson standardně ignoruje neznámá pole; aplikace musí určit, zda je to žádoucí.

Úvodní program je ukázka zápisu a následného načtení vlastního souboru: při každém běhu soubor přepíše. Při zkoušení poškozeného vstupu nejdřív spusť zápis, potom řádek s `writeString` vynech a uprav soubor. Jinak by se chyba před čtením přepsala platnými daty. V reálném načítání nikdy automaticky nepřepisuj poškozený soubor výchozími hodnotami.

## Pole objektů a generické typy

Pro jednoduchý seznam můžeš použít `Profile[] profiles = gson.fromJson(text, Profile[].class);`. Výsledek je pole profilů; ověř, že celé pole ani jeho jednotlivé položky nejsou `null`. Pro `List<Profile>` nestačí `List.class`, protože se ztratí informace o prvku. S importy `java.util.List` a `com.google.gson.reflect.TypeToken` použij:

```java
List<Profile> profiles = gson.fromJson(
        "[{\"name\":\"Ada\",\"points\":12}]",
        new TypeToken<List<Profile>>() {}.getType());
System.out.println(profiles.get(0).name()); // Ada
```

`TypeToken` uchová úplný generický typ. Prázdné `{}` vytvářejí anonymního potomka, ze kterého knihovna informaci přečte. `getType()` ji předá Gsonu. Pro začátek je jednodušší pole; tento zápis vysvětluje, proč samotný import `List` nestačí.

## Jakou roli má Jackson

Jackson je jiná knihovna pro stejné úlohy. Například v Jackson 2 poskytuje `ObjectMapper.writeValueAsString(objekt)` serializaci a `readValue(text, Profile.class)` deserializaci. Potřebuje vlastní závislost `com.fasterxml.jackson.core:jackson-databind`, kterou náš příklad nepoužívá. Nemíchej návody pro různé hlavní verze a různé knihovny. V tomto kurzu si praktický převod ověříme Gsonem a jeho pevně uvedenou verzí.

Změň jméno na text s uvozovkou a českou diakritikou. Zpětně načtená hodnota musí být stejná. Potom zkus záporné body a JSON s chybějící uzavírací závorkou: jedna chyba porušuje pravidlo aplikace, druhá samotný formát.
