## Co patří objektu a co třídě

Každý lístek má vlastní majitelku, ale prodejní místo potřebuje jeden společný počet vydaných lístků. Jméno proto uložíme do **instančního pole** každého objektu. Společné počítadlo označíme `static`: patří třídě a její objekty ho sdílejí v rámci daného načtení třídy. Navazujeme na [zapouzdření](lesson:encapsulation-overview).

## Dva objekty, společný počet

Celý program patří do `Main.java`:

```java
class Ticket {
    public static final int MAX_SEATS = 30;
    private static int issued = 0;
    private final String owner;

    public Ticket(String owner) {
        this.owner = owner;
        issued++;
    }

    public String getOwner() {
        return owner;
    }

    public static int getIssued() {
        return issued;
    }
}

public class Main {
    public static void main(String[] args) {
        Ticket first = new Ticket("Ada");
        Ticket second = new Ticket("Eva");
        System.out.println(first.getOwner());  // Ada
        System.out.println(second.getOwner()); // Eva
        System.out.println(Ticket.getIssued()); // 2
        System.out.println(Ticket.MAX_SEATS);   // 30
    }
}
```

Každé `new Ticket(...)` nastaví vlastní `owner`, ale zvýší stejné `issued`. `getOwner()` potřebuje konkrétní objekt před tečkou. `getIssued()` voláme přes název třídy `Ticket`, aby byl společný kontext vidět. Statická metoda nemá `this`; bez předaného objektu neví, čí jméno má číst. Konstruktory statické nejsou.

Do `final String owner` můžeš uložit jméno v konstruktoru. Později už tomuto poli jinou hodnotu nepřiřadíš. `static final int MAX_SEATS` je zde společná číselná **konstanta**. Názvy konstant obvykle používají velká písmena s podtržítky. Konstanta sama nevynucuje kapacitu: rezervaci by musela kontrolovat další metoda. `issued` počítá všechny vytvořené lístky, ne právě živé objekty ani obsazená sedadla.

## Proč je main static

Vstupní metoda `public static void main(String[] args)` se v našich programech spustí bez vytváření instance `Main`. Proto pomocná metoda `static int square(int n)` jde volat přímo z `main`. Instanční variantu bys volala přes objekt. `void` stále znamená žádnou návratovou hodnotu; se sdílením stavu nesouvisí.

Metody typu `Math.max(3, 7)` jsou statické, protože výsledek závisí jen na argumentech. Pro nákupní košík je přirozená instanční `total()`: záleží na položkách konkrétního košíku. Rozhodnutí tedy vychází z významu operace, nikoli z toho, že statickou metodu je kratší zavolat.

## Inicializace a životnost

Při inicializaci třídy se provedou statické inicializátory v pořadí zápisu. Někdy uvidíš blok:

```java
static {
    issued = 0;
}
```

Patřil by dovnitř `Ticket`, mimo metody. Pro nulu je zbytečný; ukazuje zápis **statické inicializace**. Neprovádí se při každém `new`. Po ukončení programu a novém spuštění začne naše počítadlo znovu: statické pole není uložení do souboru.

Když první test vytvoří dva lístky, druhý test ve stejném běhu může začínat s `issued` rovným 2. Očekávání „nový lístek zvýší počet z nuly na jedna“ pak nevyjde, přestože samotný konstruktor funguje. Tak může společný měnitelný stav propojit jinak nezávislé testy. Pro běžná aplikační data proto nejprve uvažuj o instanci, kterou lze vytvořit čerstvou. Více vláken by navíc vyžadovalo synchronizaci; příklad je určen pro jednovláknový program.

## Zkus změnu a předpověz důsledek

Vytvoř třetí lístek: počet bude `3`, první majitelka zůstane Ada. Potom myšlenkově odstraň `static` z `issued`: každý lístek by měl vlastní počítadlo a statická `getIssued()` by se už nepřeložila. Vysvětli chybu vlastními slovy.

> [!OPTIONAL] Pod povrch: inicializace třídy
>
> Inicializace třídy a vytvoření instance jsou dvě různé události. Statická pole dostanou nejprve výchozí hodnoty a inicializační výrazy i bloky se provedou při inicializaci třídy. Java řídí inicializaci tak, aby proběhla bezpečně vůči souběžnému použití.
>
> Tvrzení „static existuje jednou na celý počítač“ by bylo chybné: identita třídy zahrnuje i její class loader, mechanismus načítání tříd. Dvě nezávislé aplikace mají vlastní stav. Ani jediná kopie uvnitř běžného programu není automaticky bezpečná pro souběžné `issued++`, protože čtení, zvýšení a zápis tvoří více kroků.
