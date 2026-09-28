## Kdy už soubor nestačí

V katalogu už nechceš pokaždé načítat všechny knihy. Potřebuješ například vybrat jen dostupné tituly jedné autorky a seřadit je podle názvu. Relační databáze uchovává data v tabulkách a umožní takový požadavek zapsat jako dotaz v jazyce **SQL**. **JDBC** je rozhraní, přes které dotaz odešle Java. Konkrétní databáze potřebuje svůj ovladač; zde použijeme H2 v paměti se závislostí připravenou v Maven starteru.

Tabulka má pojmenované sloupce a řádky. PRIMARY KEY jednoznačně určuje řádek, NOT NULL zakazuje chybějící hodnotu. Cizí klíč neboli FOREIGN KEY odkazuje na klíč související tabulky, například výpůjčka na knihu. SQL NULL je chybějící databázová hodnota: zjišťuje se přes IS NULL, nikoli rovností `= NULL`.

## Čtyři základní operace

```sql
CREATE TABLE books (
    id INT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    available BOOLEAN NOT NULL
);
INSERT INTO books VALUES (1, 'Emma', TRUE);
SELECT id, title FROM books WHERE available = TRUE ORDER BY title;
UPDATE books SET available = FALSE WHERE id = 1;
DELETE FROM books WHERE id = 1;
```

`SELECT` čte, `INSERT` přidává, `UPDATE` mění a `DELETE` maže. V ukázce nejprve vložíme Emmu jako dostupnou, potom ji označíme za vypůjčenou a nakonec její záznam odstraníme. Bez WHERE se změna nebo odstranění může týkat všech řádků. ORDER BY určuje pořadí; bez něj se na pořadí výstupu nespoléhej. Agregace COUNT(*) spočítá řádky. Pro propojení tabulek slouží JOIN podle odpovídajících klíčů. Index může zrychlit hledání, ale zabírá místo a musí se aktualizovat při zápisu.

## Hodnoty odděl od příkazu

Následující metoda patří dovnitř Main ze starteru, který už poskytuje připojení db a importy java.sql:

```java
static int borrow(java.sql.Connection db, int id) throws java.sql.SQLException {
    String sql = "UPDATE books SET available = FALSE WHERE id = ? AND available = TRUE";
    try (java.sql.PreparedStatement update = db.prepareStatement(sql)) {
        update.setInt(1, id);
        return update.executeUpdate();
    }
}
```

Otazník je parametr. `setInt` váže hodnotu na první pozici, počítanou od jedné. `executeUpdate` vrátí počet změněných řádků: jedna znamená úspěšnou výpůjčku, nula neexistující nebo už vypůjčenou knihu. Podmínka a změna jsou v jednom SQL příkazu; oddělené čtení a pozdější zápis by se při souběhu mohly rozejít.

Pro SELECT použij executeQuery, které vrací ResultSet. Kurzor začíná před prvním řádkem; next ho posune a oznámí, zda existuje. `getString("title")` přečte sloupec aktuálního řádku. ResultSet i PreparedStatement uzavři přes try-with-resources. Výjimka SQLException není totéž jako žádné výsledky.

## Několik změn jako jeden celek

Čtenářka si půjčí Emmu: kniha se má označit jako nedostupná a do evidence se má přidat výpůjčka. Kdyby uspěl jen první krok, kniha by zmizela z nabídky, ale nevěděli bychom, kdo ji má. **Transakce (transaction)** dovolí potvrdit oba kroky společně nebo při chybě oba vrátit. Na připojení, které pro tuto operaci vlastníš, vypni automatické potvrzování pomocí setAutoCommit(false), proveď oba příkazy a zavolej commit. Při chybě proveď rollback a chybu předej dál. V produkční službě patří hranice transakce tam, kde lze rozhodnout o celé operaci, nikoli náhodně do každé pomocné metody.

Transakce sama neřeší všechny konflikty: záleží i na izolaci, omezeních a způsobu aktualizace. Počet upravených řádků proto kontroluj. Na vypůjčeném připojení neměň bez domluvy režim ostatním částem aplikace.

## Malý opakovatelný experiment

Starter založí tabulku, vloží několik knih a po ukončení databázi zahodí. Nemusíš instalovat server. Procvič dostupnou knihu, vypůjčenou knihu, neexistujícího autora a apostrof v názvu. Hodnotu vždy předávej přes parametr; uvozovky ručně neslepuj. Plný starter i referenční řešení jsou obyčejný Maven projekt a nepředpokládají framework.
