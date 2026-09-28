## Pošli program tak, aby šel spustit

Kamarádka chce vyzkoušet tvůj program, ale nemá otevřený tvůj projekt v editoru. Připravíš jí proto archiv **JAR** s přeloženými třídami a příkaz ke spuštění. Editor za tebe dosud vybíral hlavní třídu, JDK, pracovní složku i knihovny; při předání musí být tyto požadavky popsané. Samotný JAR neobsahuje instalaci Javy.

Celý soubor `src/main/java/Main.java` přijme jméno jako argument:

```java
public class Main {
    public static void main(String[] args) {
        if (args.length != 1 || args[0].isBlank()) {
            System.out.println("Pouziti: java -jar greeting.jar Jmeno");
            return;
        }
        System.out.println("Ahoj, " + args[0].strip());
    }
}
```

`args` obsahuje argumenty předané za jménem třídy nebo archivu. Například po spuštění `java -jar greeting.jar Enid` bude mít jeden prvek a `args[0]` bude text `"Enid"`. Není to totéž co řádky čtené ze Scanneru. Shell rozdělí vstup na argumenty; uvozovky pomohou zachovat jméno s mezerami jako jediný argument. Program samotný obalující uvozovky v běžném použití nedostane.

## Překlad, archiv, spuštění

Příkazy spusť ze složky projektu:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java
jar --create --file greeting.jar --main-class Main -C out .
java -jar greeting.jar "Ada Novakova"
jar --list --file greeting.jar
```

Překladač uloží třídy do out. Nástroj jar vloží obsah této složky do archivu; přepínač -C se vztahuje na výběr vstupních souborů, nemění trvale pracovní složku terminálu. Main-Class v manifestu určí vstupní třídu. Pokud je v balíčku app, nastav app.Main včetně balíčku.

Release 21 nastavuje kompatibilitu jazyka, API i formátu tříd pro Javu 21. Samo nepřibalí JVM ani cizí knihovny. Starší Java může odmítnout bytecode novějšího vydání; v návodu proto uváděj skutečný minimální požadavek. Náš program bez závislostí lze spustit s JDK 21 nebo novějším.

## Kam ukládat soubory aplikace

Prostředek přibalený do JAR, například výchozí šablona, se čte jako resource z classpath. Není to běžný zapisovatelný soubor vedle Main.java. Uživatelská data naopak ukládej do výslovně zvolené externí cesty. Relativní Path.of("data.txt") závisí na pracovní složce, nikoli na umístění archivu; přesun nebo spuštění z jiné složky to rychle odhalí.

Z toho plyne jednoduchý test: zkopíruj pouze JAR do nové prázdné složky, otevři tam terminál a spusť skutečný distribuční příkaz. Pokud program potřebuje nezmíněný zdrojový soubor nebo konfiguraci editoru, balíček ještě není hotový.

## Závislosti a automatické sestavení

Obyčejný JAR obvykle neobsahuje závislosti automaticky. Maven může pomocí příslušného pluginu vytvořit archiv se závislostmi, jak ukazuje StudyDesk. Jpackage dovede vytvořit balíček s běhovým prostředím pro konkrétní cílový systém; to je další krok, který vyžaduje sestavení a ověření na dané platformě.

Pro opakované vydávání patří do automatické kontroly čistý překlad, testy, vytvoření archivu a krátké zkušební spuštění výsledku. Takovou kontrolu může po každé změně spouštět server; tomuto průběžnému ověřování se říká **CI (continuous integration)**. V této misi zůstaneme u malého JAR bez závislostí, přesného návodu a chybových argumentů.
