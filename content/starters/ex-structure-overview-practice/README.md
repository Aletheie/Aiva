# Lea chce vidět jen to, co ještě zbývá

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Lea se chystá na další studijní večer. Git už má hotový, v Javě jí zbývá několik úkolů a Ema navrhuje začít tím, co ještě potřebuje pozornost. Lea si proto přeje krátký přehled otevřené práce.

První pokus ho vytvoří tím, že dokončené položky smaže. Přehled je sice krásně stručný, ale Lea ztratila záznam toho, co zvládla. Potřebuje nový pohled na stejná data, aby mohla plánovat pokračování a později se vrátit i k hotovým věcem.

</details>
<!-- aiva-story:end -->

Lea má na studijním seznamu hotový Git a rozpracovanou Javu. Pomoz jí zobrazit jen zbývající práci, aniž by dokončené úkoly zmizely z původních dat.

Do `TaskService` přidej `List<String> openTitles(List<Task> tasks)`. Vrať názvy nedokončených úkolů seřazené přirozeně. V `Main` ověř dvojici `Java/false` a `Git/true`: výsledek má být `[Java]`. Prázdný seznam dává `[]`.

Služba má vracet data; samotný výpis nech v `Main`. Čtení konzole ani cesta k souboru do této metody nepatří.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Balíčky odpovídají cestám a projekt se přeloží.
- Výsledek je [Java], pro prázdný vstup [].
- Služba nemá konzolové ani souborové operace.
