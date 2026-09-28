## Cesta není otevřený soubor

Poznámky v proměnné po ukončení programu ztratíš. Aby zůstaly i na příště, uložíme je do `notes.txt`. Nejdřív potřebujeme určit místo: `Path` popisuje cestu a `Files` poskytuje operace pro čtení a zápis. Samotné `Path.of("notes.txt")` ještě soubor nevytvoří, jen připraví cestu pro pozdější čtení nebo zápis. Relativní cesta se vyhodnocuje vůči pracovnímu adresáři spuštěného procesu, který nemusí být složkou zdrojového souboru v IDE. Absolutní cesta začíná kořenem disku nebo souborového systému.

Navazuješ na [výjimky](lesson:exceptions-overview). Soubor může chybět, být nepřístupný nebo se během práce změnit; operace proto často vyvolávají `IOException`.

## Zápis a čtení celého textu

Celý program ulož do `Main.java` a spusť v cvičné složce:

```java
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;

public class Main {
    public static void main(String[] args) {
        Path directory = Path.of("practice-data");
        Path file = directory.resolve("notes.txt");
        try {
            Files.createDirectories(directory);
            Files.writeString(file, "Příliš žluťoučký kůň\n", StandardCharsets.UTF_8);
            Files.writeString(file, "Druhý řádek\n", StandardCharsets.UTF_8,
                    StandardOpenOption.APPEND);
            String text = Files.readString(file, StandardCharsets.UTF_8);
            System.out.print(text);
        } catch (IOException error) {
            System.out.println("Soubor nelze zpracovat: " + error.getMessage());
        }
    }
}
```

`resolve("notes.txt")` připojí jméno k cestě adresáře přenosně mezi systémy. `createDirectories` vytvoří chybějící adresáře v cestě; existující adresář nevadí. `writeString` bez voleb vytvoří soubor nebo **přepíše jeho obsah**. Další volání s `APPEND` přidá text na konec již existujícího souboru. Pro vytvoření nebo přidání bys předala také `StandardOpenOption.CREATE`.

`readString` načte celý text. `StandardCharsets.UTF_8` je konstanta určující převod znaků na bajty a zpět. Obě strany používají stejné kódování, takže diakritika zůstane zachována. `\n` zapisuje nový řádek. `print` na rozdíl od `println` nepřidá další zalomení: text ho již obsahuje.

## Řádky a velké soubory

`Files.readAllLines(file, StandardCharsets.UTF_8)` vrátí `List<String>` s řádky bez oddělovačů. `Files.write(file, rows, StandardCharsets.UTF_8)` zapíše kolekci řádků s oddělovači systému. Obě operace jsou vhodné pro malé školní soubory. Celý velký soubor by zbytečně zabral paměť.

Pro průběžné čtení přidej `import java.io.BufferedReader;` a místo vnitřku předchozího `try` použij tento samostatný blok:

```java
try (BufferedReader reader = Files.newBufferedReader(file, StandardCharsets.UTF_8)) {
    String line;
    while ((line = reader.readLine()) != null) {
        System.out.println(line);
    }
} catch (IOException error) {
    System.out.println("Čtení selhalo: " + error.getMessage());
}
```

`newBufferedReader` otevře čtenář s vyrovnávací pamětí. `readLine()` vrací řádek bez zalomení, na konci `null`; prázdný řádek je `""`, nikoli konec. V podmínce nejprve přiřadíme načtenou hodnotu do `line`, pak ji porovnáme s `null`. `try-with-resources` čtenář automaticky uzavře i při výjimce.

Pozdější `Files.lines(...)` vrací stream řádků. Také vyžaduje uzavření pomocí `try-with-resources`; konkrétní zpracování patří do [Stream API](lesson:streams-overview). Názvem stream se označují i vstupně-výstupní proudy bajtů; nejsou totéž co operace `filter` a `map`.

## Kontroly a běžné pasti

`file.toAbsolutePath()` ukáže, kde program cestu hledá. `Files.exists(file)` zjišťuje existenci, `Files.isDirectory(file)` adresář. Kontrola není záruka, že následující čtení uspěje: mezi kroky se soubor může změnit. Navíc `exists` může vrátit `false`, pokud existenci nelze určit. Čtení proto stejně řeší výjimky. Pro přesné rozlišení chybějícího souboru lze zachytit `NoSuchFileException` před obecnější `IOException`.

Když poznámky nejdou přečíst, neznamená to, že žádné nemáš. Soubor může existovat a obsahovat důležité údaje, i když je některý řádek poškozený. Načti do pomocné kolekce, ověř každý řádek a až po úspěchu nahraď data v aplikaci. Při chybě nepřepisuj původní obsah prázdným seznamem. Pro důležitá data lze zapsat do vedlejšího dočasného souboru a poté přesunout pomocí `Files.move`; atomický přesun s volbou `ATOMIC_MOVE` nemusí daný souborový systém podporovat.

## Starší File API

`java.io.File` také popisuje cestu, nikoli obsah; `new File("notes.txt").toPath()` ji převede na `Path`. `FileReader` čte znaky a `FileWriter` zapisuje znaky. S konstruktorem `new FileReader(file.toFile(), StandardCharsets.UTF_8)` nastavíš kódování; čtenář uzavírej stejně jako výše. `Path.toFile()` převádí lokální cestu na `File`. Nový kód kurzu používá `Files`, protože spojuje čitelné operace s explicitním kódováním.

Spusť příklad dvakrát: soubor bude stále obsahovat dva řádky, protože první zápis ho přepíše. Potom změň první zápis na přidávání s `CREATE` a `APPEND` a předpověz, proč počet řádků roste.

> [!OPTIONAL] Pod povrch: znaky, bajty a buffer
>
> Soubor obsahuje bajty. Kódování, například UTF-8, určuje, které sekvence bajtů představují znaky. Počet písmen proto nemusí odpovídat počtu bajtů souboru. Čtení špatným kódováním může dát nesmyslný text nebo chybu dekódování.
>
> BufferedReader načítá data po blocích do **bufferu**, dočasné paměti, aby nemusel pro každý znak žádat operační systém. Writer může obdobně část výstupu držet v bufferu; `flush()` požádá o jeho předání dále a `close()` prostředek uzavře. Ani samotný flush není obecná záruka fyzického zápisu na odolné úložiště při výpadku proudu. Pro náš kurz stačí korektní uzavření a zachování starých dat při neúspěšném načtení.
