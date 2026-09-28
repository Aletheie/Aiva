# Matilda hledá knihu, která je opravdu v regálu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Matilda · současná variace**

Matilda má v knihovně připravený další seznam čtení a paní Phelps jí pomáhá vybrat knihy od oblíbeného autora. Digitální katalog ale nabízí i výtisky, které jsou právě u jiných čtenářů. Jedno příjmení s apostrofem navíc celé hledání zastaví.

Matilda se kvůli tomu nechce vzdát ani autora, ani odpoledního čtení. Potřebuje přehled knih, které skutečně najde v regálu, a dotaz, který zachází se zadaným jménem jako s údajem. Pak může řešit mnohem příjemnější otázku: kterou začne.

</details>
<!-- aiva-story:end -->

Matilda ze stejnojmenné knihy chce doporučení z knihovny. Katalog jí nesmí nabízet právě vypůjčené tituly a příjmení s apostrofem nesmí rozbít dotaz. Pomoz jí získat dostupné knihy vybraného autora.

Doplň pouze `availableByAuthor(Connection db, String author)`. Vrať názvy knih s přesně shodným autorem a available = TRUE, seřazené podle title vzestupně. Použij PreparedStatement a parametr ?, nikoli spojování SQL se vstupem. Prázdný výsledek je prázdný seznam. SQLException neskrývej jako žádné knihy. Uzavři statement i ResultSet, ale nezavírej připojení, které spravuje volající.

Připravený Main při každém spuštění založí databázi H2 pouze v paměti a naplní ji cvičnými knihami. Neukládá ani nemaže žádný skutečný katalog. Čtyři dotazy musejí vypsat:

```text
Austen: [Emma]
O'Neil: [Morning tales]
Unknown: []
' OR '1'='1: []
```

Poslední vstup je doslovné jméno autora, nikoli část SQL příkazu. Druhá kniha od Jane Austen se neukáže, protože je vypůjčená. Přidej do cvičných dat ještě jednu dostupnou knihu a ověř řazení. Maven a první stažení závislostí vyžadují připojení; pak samotná databáze pracuje lokálně. Kontrola v AIVA je ruční. Viz [SQL a JDBC](lesson:sql-and-jdbc).

## Spuštění

JDK 21+ a Maven. Otevři pom.xml jako Maven projekt nebo spusť ze složky cvičení:

```sh
mvn -q compile exec:java
```

Při prvním běhu Maven stáhne připnuté závislosti. Databáze je v paměti a po ukončení zmizí. AIVA Maven automaticky nespouští.

## Ověření

- Všechny čtyři dotazy dávají přesný očekávaný výsledek.
- Další dostupná kniha je na správné pozici podle title.
- Autor se vkládá přes setString, nikdy spojením SQL řetězce.
- ResultSet a PreparedStatement se uzavřou, připojení zůstává použitelné.
- Chyba SQL se neoznačuje za úspěšný prázdný výsledek.
