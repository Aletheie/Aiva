## Co má dělat úkol, služba a úložiště

V plánovači potřebuješ zadat úkol, spočítat zbývající práci a uložit seznam. Když tyto činnosti rozdělíš, můžeš změnit formát souboru bez zásahu do počítání úkolů. Každá část má konkrétní práci:

- **Model** `Task` uchovává název a informaci, zda je úkol hotový. Odmítá prázdný název.
- **Služba (service)** zde spočítá nedokončené úkoly.
- **Úložiště (repository)** seznam načte nebo uloží.
- **Uživatelské rozhraní** přečte příkaz a zobrazí výsledek.

Malý program může začít ve dvou třídách; další části odděl, když to usnadní změny nebo testování. Například počet úkolů vyzkoušíš přímo nad seznamem v paměti a nemusíš pokaždé psát příkazy do konzole. Navazuješ na [návrh OOP a UML](lesson:oop-design), [rozhraní](lesson:interfaces-overview) a [týmovou spolupráci](lesson:collaboration-overview).

## Balíčky odpovídají adresářům

**Package** seskupuje související typy a tvoří část jejich úplného jména. Konvence používá malá písmena a často obrácenou doménu autora. Například `cz.kurz.model.Task` patří do `src/main/java/cz/kurz/model/Task.java`:

```java
package cz.kurz.model;

public record Task(String title, boolean done) {
    public Task {
        if (title == null || title.isBlank()) {
            throw new IllegalArgumentException("Úkol potřebuje název");
        }
    }
}
```

Řádek `package` musí být před importy. `public` zpřístupní typ i jinému balíčku. Record nabízí konstruktor, `title()` a `done()`; kompaktní konstruktor ověřuje vstup. `done` se po vytvoření nepřiřazuje, takže dokončení můžeme vyjádřit novým záznamem se stejným názvem a hodnotou `true`.

`src/main/java/cz/kurz/service/TaskService.java`:

```java
package cz.kurz.service;

import cz.kurz.model.Task;
import java.util.List;

public class TaskService {
    public long countOpen(List<Task> tasks) {
        return tasks.stream().filter(task -> !task.done()).count();
    }
}
```

`import` dovolí používat krátké jméno `Task`. Neinstaluje knihovnu ani nekopíruje třídu. `countOpen` vrací `long`, protože jej vrací terminální `count()`. `!task.done()` ponechává nedokončené úkoly. Seznam ani jednotlivé úkoly se nemění.

`src/main/java/cz/kurz/Main.java`:

```java
package cz.kurz;

import cz.kurz.model.Task;
import cz.kurz.service.TaskService;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<Task> tasks = List.of(new Task("Java", false), new Task("Git", true));
        TaskService service = new TaskService();
        System.out.println(service.countOpen(tasks)); // 1
    }
}
```

Po `mvn compile` lze tento příklad bez externích knihoven spustit `java -cp target/classes cz.kurz.Main`. Úplné jméno třídy obsahuje balíček, nikoli cestu se lomítky.

## Načítání a ukládání za společným rozhraním

Když přidáš soubory, rozhraní může vypadat takto v `cz/kurz/storage/TaskRepository.java`:

```java
package cz.kurz.storage;

import cz.kurz.model.Task;
import java.io.IOException;
import java.util.List;

public interface TaskRepository {
    List<Task> load() throws IOException;
    void save(List<Task> tasks) throws IOException;
}
```

`load` načte seznam a `save` uloží předaný stav; `throws IOException` přiznává možnost selhání. Implementace může používat [JSON](lesson:json-overview), ale služba nepotřebuje znát Gson. Samotné rozhraní ukládání neprovádí: musíš dodat konkrétní implementaci a předat jí například `Path` přes konstruktor.

U prvního spuštění může chybějící soubor znamenat, že ještě nejsou uložené žádné úkoly. Poškozený soubor ale oznam jako chybu. Aplikace má při poškození zobrazit chybu načítání a zachovat původní data; nemá tvrdit, že načetla prázdný seznam. Pokud změníš model, promysli i starší uložená data a chybějící pole.

## Od námětu k předatelnému projektu

První etapa: napiš 3–5 scénářů a doménové třídy, jeden scénář zprovozni v paměti. Druhá: zvol kolekce, validaci a řízení chyb. Třetí: popiš formát dat a přidej načtení i zápis včetně chyb. Čtvrtá: otestuj pravidla, přidej build, README a ověř spuštění v nové kopii repozitáře.

**Konfiguraci** nastav při spouštění programu: například `Path.of("tasks.json")` v `main` se předá úložišti. Pokud je cesta zapsaná na deseti místech, každá změna prostředí je nebezpečnější. **Refaktoring** rozdělí odpovědnosti, ale má zachovat pozorované výsledky; opři ho o testy.

Při prezentaci ukaž jeden úspěšný scénář a jedno selhání, ze kterého se aplikace zotaví. Ukaž například, kde program odmítne prázdný název, který test to ověřuje a ve kterém souboru po ukončení zůstanou uložené úkoly.

> [!OPTIONAL] Pod povrch: metody ve starteru StudyDesk
>
> StudyDesk používá i ruční strom JSON a několik souborových operací. Tento samostatný `Main.java` v Maven projektu s Gsonem ukáže strom na jediném úkolu:
>
> ```java
> import com.google.gson.Gson;
> import com.google.gson.JsonArray;
> import com.google.gson.JsonObject;
> import com.google.gson.JsonParser;
> import java.util.UUID;
>
> public class Main {
>     public static void main(String[] args) {
>         UUID id = UUID.randomUUID();
>         JsonObject task = new JsonObject();
>         task.addProperty("id", id.toString());
>         task.addProperty("title", "Procvičit Javu");
>         task.addProperty("completed", false);
>         JsonArray tasks = new JsonArray();
>         tasks.add(task);
>         JsonObject root = new JsonObject();
>         root.addProperty("schemaVersion", 1);
>         root.add("tasks", tasks);
>
>         Gson gson = new Gson();
>         String json = gson.toJson(root);
>         JsonObject loaded = JsonParser.parseString(json).getAsJsonObject();
>         if (!loaded.has("schemaVersion") || loaded.get("schemaVersion").getAsInt() != 1) {
>             throw new IllegalArgumentException("Neznámá verze");
>         }
>         JsonObject first = loaded.getAsJsonArray("tasks").get(0).getAsJsonObject();
>         UUID restored = UUID.fromString(first.get("id").getAsString());
>         System.out.println(restored.equals(id)); // true
>         System.out.println(first.get("title").getAsString()); // Procvičit Javu
>         System.out.println(first.get("completed").getAsBoolean()); // false
>     }
> }
> ```
>
> `UUID` je 128bitový identifikátor. `randomUUID()` vytváří náhodnou variantu s velmi malou pravděpodobností kolize; není to absolutní důkaz jedinečnosti. `toString()` poskytne obvyklý textový zápis a `fromString(text)` jej přečte, nebo odmítne neplatný zápis výjimkou. Identifikátor vytvářej při založení úkolu, ne při každém načtení, jinak se změní jeho identita.
>
> `JsonObject` a `JsonArray` reprezentují uzly stromu. `addProperty(jméno, jednoducháHodnota)` vloží text, číslo nebo boolean. `add(jméno, uzel)` přidá vnořený objekt nebo pole. `JsonArray.add(uzel)` přidá prvek na konec. `JsonElement` je jejich společný základní typ. `gson.toJsonTree(objekt)` také vytvoří strom z Java dat, zatímco toJson vrací text.
>
> `JsonParser.parseString` přečte text do stromu. `getAsJsonObject()` vyžaduje objekt, `getAsJsonArray("tasks")` přečte pole daného jména a `get(0)` jeho první prvek. `has(jméno)` zjišťuje přítomnost položky, `get(jméno)` ji vrací. `getAsString`, `getAsInt` a `getAsBoolean` převádějí jednoduché hodnoty. Tyto gettery nejsou úplná validace schématu: některé hodnoty převádějí a pro chybějící nebo jiný uzel mohou selhat. Příklad pracuje se svým vlastním vytvořeným dokumentem; cizí vstup vyžaduje ověření struktury a hodnot před použitím.
>
> Souborové pomocníky ze starteru čti takto:
>
> | Operace | Účel a malý příklad |
> |---|---|
> | `Path.of("data", "tasks.json")` | Spojí části cesty bez ručního oddělovače systému. |
> | `file.toAbsolutePath().normalize()` | Vyjádří cestu absolutně a zjednoduší části jako `.`; normalize neověří existenci ani symbolické odkazy. |
> | `file.getParent()` | Rodičovská cesta; pro absolutní cestu souboru určí adresář dat. |
> | `Files.size(file)` | Velikost souboru v bajtech, nikoli počet znaků; 4 × 1024 × 1024 je 4 MiB. |
> | `Files.createTempFile(parent, ".studydesk-", ".json")` | Vytvoří pomocný soubor s unikátním jménem ve zvoleném adresáři a vrátí jeho Path. |
> | `Files.move(temp, file, StandardCopyOption.REPLACE_EXISTING)` | Přesune pomocný soubor na cílovou cestu a dovolí nahrazení dosavadního cíle. |
> | `StandardCopyOption.ATOMIC_MOVE` | Žádá přesun jako jednu nedělitelnou souborovou operaci; nepodporované prostředí vyvolá AtomicMoveNotSupportedException. |
> | `Files.deleteIfExists(temp)` | Odstraní zbylý pomocný soubor, pokud existuje; může selhat chybou I/O. |
>
> Pro tyto operace importuj `java.nio.file.Files`, `Path`, `StandardCopyOption` a případně `AtomicMoveNotSupportedException`. Zápis do pomocného souboru před přesunem snižuje riziko částečného přepsání cíle. Náhradní neatomický přesun ale nemá stejnou záruku; starter neřeší souběžné zapisování více procesů ani všechny následky výpadku napájení.
>
> `new IOException("popis", cause)` uchová původní výjimku jako příčinu; tu vrátí `getCause()`. Chybu formátu tak lze předat jako chybu načítání bez ztráty původního detailu. `Objects.requireNonNull(repository)` ve službě odmítne chybějící závislost. `List.copyOf` brání vnější změně seznamu a `getFirst()` vrací první prvek, ale na prázdném seznamu vyvolá NoSuchElementException.
>
> `System.exit(1)` ve vstupní třídě ukončí proces s nenulovým stavovým kódem signalizujícím neúspěch. Běžné `return` ukončuje jen dané volání metody. Když chceš tuto větev testovat jako jednotku, odděl načítací logiku od samotného ukončení procesu.
