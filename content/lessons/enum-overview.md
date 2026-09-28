## Když existuje konečná sada stavů

Na nástěnce úkolů jsou tři sloupce: Čeká, Probíhá a Hotovo. Pro uložení těchto stavů se hodí **výčtový typ (enum)**, který předem pojmenuje povolené hodnoty. Místo libovolného textu `"hotovo"`, `"Hotovo"` nebo chybného `"hotvo"` pak proměnná přijme jen jednu z nich. Překlep v názvu konstanty zachytí překladač.

Použijeme [switch](lesson:more-branches) a [instanční metody](lesson:constructors). Enum je samostatný typ; jeho konstanty jsou objekty příslušného typu.

## Stav s čitelným popiskem

Celý příklad ulož do `Main.java`:

```java
enum TaskStatus {
    TODO("Čeká"),
    ACTIVE("Probíhá"),
    DONE("Hotovo");

    private final String label;

    TaskStatus(String label) {
        this.label = label;
    }

    public String label() {
        return label;
    }
}

public class Main {
    public static void main(String[] args) {
        TaskStatus status = TaskStatus.ACTIVE;
        System.out.println(status.label()); // Probíhá
        System.out.println(status == TaskStatus.DONE); // false
        int remaining = switch (status) {
            case TODO -> 2;
            case ACTIVE -> 1;
            case DONE -> 0;
        };
        System.out.println(remaining); // 1
    }
}
```

`TODO("Čeká")` vytvoří pojmenovanou konstantu a předá text konstruktoru. Enum konstruktor není veřejný; vlastní `new TaskStatus(...)` psát nesmíš. Pole `label` uchovává český popisek a metoda `label()` ho vrací. Středník za `DONE(...)` odděluje seznam konstant od dalších členů.

Hodnoty enum bezpečně porovnáváme `==`, protože jde o jedinečné pojmenované instance. `status == TaskStatus.DONE` je bezpečné i při `status == null`; samotný `switch` v ukázce ale s `null` nepočítá. Místo nejasného nulového stavu si zvol platný výchozí stav.

## Převod a výčet hodnot

Následující řádky patří do `main` stejného programu:

```java
TaskStatus parsed = TaskStatus.valueOf("TODO");
System.out.println(parsed.name()); // TODO
for (TaskStatus value : TaskStatus.values()) {
    System.out.println(value.label());
}
```

`valueOf(String)` hledá přesný název konstanty, rozlišuje velikost písmen a pro `"todo"` vyvolá `IllegalArgumentException`. Není to tolerantní čtení libovolného uživatelského popisku. `name()` vrací původní název konstanty. `values()` vrací pole všech konstant v pořadí deklarace; cyklus vypíše Čeká, Probíhá a Hotovo.

Existuje i `ordinal()`, vracející pořadí od nuly. Neukládej ho jako trvalý identifikátor do souboru: vložení dalšího stavu mezi staré hodnoty změní význam uloženého čísla. Stabilní pojmenované kódy jsou pro formát souboru srozumitelnější.

## Modelování přechodů

Enum omezuje seznam hodnot, ale samo nehlídá povolené přechody. Pokud úkol smí jít z TODO do ACTIVE a teprve pak do DONE, musí to vynutit metoda objektu úkolu. Nástěnka tedy zná tři sloupce, ale sama nezakáže přesunout kartičku rovnou z Čeká do Hotovo. Pokud takový přesun nechceš dovolit, musí ho zkontrolovat další kód.

U výrazu `switch` jsme pokryli všechny konstanty, takže není potřeba `default`. Když přidáš `CANCELLED`, překladač tě upozorní na neúplný výraz. To je užitečné při rozšiřování aplikace: musíš se rozhodnout, co nový stav znamená.

Zkus přidat Zrušeno a upravit výpočet zbývajících kroků. Pak vypiš všechny popisky pomocí `values()`. Vysvětli, proč už samotné přidání řetězce do seznamu textů podobnou kontrolu překladače neposkytuje.
