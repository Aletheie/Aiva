## Kdo má na starosti výpůjčku

Pro malý program s Hermioninými knihami potřebuješ vědět, která kniha je právě půjčená. Toto pravidlo patří ke knize: při výpůjčce změní dostupnost a další výpůjčku odmítne. Čtení příkazu z konzole může dělat jiná část programu. Navazuješ na [zapouzdření](lesson:encapsulation-overview) a rozhoduješ, co má která třída na starosti.

Zadání „evidence knih a výpůjček“ rozděl nejprve slovně. Kniha zná název a dostupnost. Výpůjčka spojuje čtenáře s knihou. Konzole čte příkazy a ukazuje výsledek. Úložiště načítá a ukládá data. Pro první verzi můžeme začít samotnou knihou a voláním jejích metod. Čtenáře nebo ukládání přidáme, až je bude zadání potřebovat.

## Kniha, kterou lze půjčit a vrátit

**Doména** je oblast, kterou program řeší; zde knihovna. Celý příklad v `Main.java`:

```java
class Book {
    private final String title;
    private boolean borrowed;

    public Book(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public boolean borrow() {
        if (borrowed) {
            return false;
        }
        borrowed = true;
        return true;
    }

    public void giveBack() {
        borrowed = false;
    }
}

public class Main {
    public static void main(String[] args) {
        Book book = new Book("Duna");
        System.out.println(book.getTitle()); // Duna
        System.out.println(book.borrow());   // true
        System.out.println(book.borrow());   // false
        book.giveBack();
        System.out.println(book.borrow());   // true
    }
}
```

`borrow()` rozhoduje podle vlastního stavu a vrací, zda změna proběhla. Nečte konzoli, takže ho později snadno zavolá test. `giveBack()` nastaví knihu jako dostupnou. Když ho zavoláš dvakrát, kniha prostě zůstane dostupná; ukázka opakované vrácení nepovažuje za chybu. `getTitle()` pouze čte. Konstruktor v ukázce předpokládá neprázdný název; doplnění validace je vhodné první rozšíření, ne úkol pro konzoli.

## Jak číst UML class diagram

**UML** je sada značek pro popis modelů. Diagram třídy má jméno, atributy a operace. Tentýž `Book` lze zapsat takto:

```text
Book
--------------------------------
- title: String
- borrowed: boolean
--------------------------------
+ Book(title: String)
+ getTitle(): String
+ borrow(): boolean
+ giveBack(): void
```

`-` znamená `private`, `+` `public`, `#` `protected`, `~` přístup v balíčku. Za dvojtečkou je typ hodnoty nebo návratový typ. Závorky označují metodu a její parametry. Statické členy se obvykle podtrhují nebo označují `{static}`.

Vztah `Library 1 — 0..* Book` říká, že k jedné knihovně může patřit nula až mnoho knih; čísla jsou **násobnosti**. Šipka s prázdným trojúhelníkem k předkovi značí dědičnost. Plný kosočtverec u celku značí kompozici se silným vlastnictvím částí. Ne každé pole s odkazem automaticky znamená silné vlastnictví: kniha může existovat i mimo konkrétní evidenci.

## God Object a nízká provázanost

**God Object** je přerostlá třída, která současně zná uživatele, kreslí menu, načítá soubory, kontroluje data a počítá statistiky. Změna formátu souboru pak může zasáhnout i výpůjčky. Rozděl ji podle odpovědností, například na `Book`, `LibraryService`, `BookRepository` a `ConsoleMenu`; jejich konkrétní realizaci doplníme později.

**Soudržnost (cohesion)** znamená, že členy třídy slouží jednomu blízkému účelu. **Provázanost (coupling)** popisuje závislosti mezi částmi. U knihy spolu název, dostupnost a výpůjčka souvisejí: to je dobrá soudržnost. Pokud by ale `Book` musela znát i barvu konzolového menu, vznikla by zbytečná závislost. Změna barvy by pak mohla nutit k úpravě třídy, která se má starat o knihy.

## První společný návrh

Ve dvojici si vyberte evidenci výdajů, knih nebo studijních úkolů. Napište tři uživatelské scénáře, například „přidám úkol“, „dokončím úkol“, „vypíšu zbývající“. Nakreslete 3–5 tříd s jednou větou o odpovědnosti každé. Nejprve realizujte jeden scénář v paměti, teprve potom ukládání.

Při párovém programování jeden člověk píše, druhý sleduje pravidla a hraniční případy. Po 15–20 minutách role prohoďte. Hotový návrh umíte vysvětlit oba; počet vytvořených tříd není kritériem úspěchu. Zkus návrh otestovat otázkou: „Dokážu ověřit výpůjčku bez konzole a bez souboru?“
