## Oznámení může mít různé způsoby doručení

Po dokončení lekce chceme poslat oznámení. Pro jednoduchou ukázku ho vypíšeme do konzole, později by ho jiná třída mohla zobrazit v aplikaci. Kód pro dokončení lekce potřebuje znát pouze operaci `send(message)`. Tu popíše **rozhraní (interface)**. Třída uvede rozhraní za `implements` a doplní metodu `send`. Navazujeme tím na [polymorfismus](lesson:polymorphism-overview).

## Vyměnitelný způsob oznámení

Ulož celý příklad do `Main.java`:

```java
interface Notifier {
    void send(String message);

    default void welcome() {
        send("Vítej v kurzu");
    }
}

class ConsoleNotifier implements Notifier {
    @Override
    public void send(String message) {
        System.out.println(message);
    }
}

class CourseService {
    private final Notifier notifier;

    public CourseService(Notifier notifier) {
        this.notifier = notifier;
    }

    public void finishLesson() {
        notifier.send("Lekce dokončena");
    }
}

public class Main {
    public static void main(String[] args) {
        Notifier notifier = new ConsoleNotifier();
        notifier.welcome();
        CourseService service = new CourseService(notifier);
        service.finishLesson();
    }
}
```

Program vypíše `Vítej v kurzu` a `Lekce dokončena`. Deklarace `void send(String message);` nemá tělo; běžná abstraktní metoda rozhraní je implicitně veřejná. Implementace proto musí mít `public`. `@Override` nechá překladač ověřit, že metoda odpovídá deklaraci v rozhraní. Metoda s `default` má tělo přímo v rozhraní. V této ukázce volá `send`, kterou doplnila konkrétní třída.

`CourseService` nedělá `new ConsoleNotifier()` uvnitř. Dostane závislost parametrem konstruktoru a uloží ji do pole. Tomu říkáme **předání závislosti (dependency injection)**; žádný framework pro tento postup nepotřebujeme. `CourseService` tak zná jen rozhraní `Notifier`. Nemusí vědět, jak funguje konzole ani budoucí oznámení v aplikaci. Tento směr závislosti se označuje jako **obrácení závislosti (dependency inversion)**.

## Abstraktní třída

**Abstraktní třída (abstract class)** může sdílet stav, konstruktor i hotové metody a přitom nechat některé operace potomkům. Příklad do samostatného souboru:

```java
abstract class Report {
    private final String title;

    protected Report(String title) {
        this.title = title;
    }

    public String heading() {
        return title;
    }

    public abstract String body();
}
```

Nadpis zprávy umíme připravit společně, ale její tělo zatím chybí: pro přehled četby bude jiné než pro přehled výdajů. Proto samotné `new Report(...)` není dovoleno. Konkrétní `class TextReport extends Report` musí zavolat `super(title)` v konstruktoru a dodat `public String body() { return "Výsledky"; }`. `heading()` zdědí hotovou. Abstraktní metoda má středník místo těla.

| Potřeba | Obvyklá volba |
|---|---|
| Zaměnitelné chování nezávislých tříd | Rozhraní |
| Společný stav a část provedení příbuzných tříd | Abstraktní třída |
| Jedna věc používá jinou | Kompozice a předání objektu |

Třída může `implements Printable, Exportable`, tedy více rozhraní, ale rozšiřovat jen jednu třídu. Pokud dvě rozhraní dodají konfliktní `default` metody, implementace musí konflikt vyřešit vlastním přepsáním. Rozhraní nemá běžná instanční pole; jeho deklarovaná pole jsou konstanty `public static final`.

## Malá rozhraní se lépe používají

Rozhraní `Notifier` nevyžaduje, aby test znal konzoli. Testovací implementace může uložit poslední zprávu do pole. Naopak rozhraní s dvaceti nesouvisejícími metodami nutí každého implementovat příliš mnoho. Navrhuj ho podle skutečného potřebného chování, například odeslání jedné zprávy.

Vyzkoušej druhý notifier, který před zprávu přidá `INFO: `. V `main` vyměň vytvořený objekt a ponech `CourseService` beze změn. Tento malý experiment ukazuje, co zaměnitelnost znamená v praxi.
