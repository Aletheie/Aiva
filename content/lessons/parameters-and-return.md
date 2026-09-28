## Výsledek pro další práci

Metoda může místo výpisu **vrátit hodnotu (return value)**:

```java
static int square(int number) {
    return number * number;
}
```

`int` před názvem říká, jaký typ výsledku metoda vrací. V `main` ho můžeš uložit:

```java
int result = square(4);
System.out.println(result); // 16
```

`return` předá hodnotu zpět a hned ukončí dané volání metody.

## Vrácení není výpis

Nela potřebuje cenu dopravy přičíst k nákupu. Když metoda jen vypíše „79 Kč“, Nela ji sice uvidí, ale další výpočet toto číslo nedostane. `return 79` předá hodnotu zpátky programu, který ji může přičíst k ceně zboží. Metoda s `void`, která pouze vypisuje, takový výsledek neposkytuje.

Proto v úlohách, kde výpis zajišťuje `main`, další výpis do výpočetní metody nepřidávej.

## Každá cesta potřebuje výsledek

```java
static int larger(int a, int b) {
    if (a > b) {
        return a;
    }
    return b;
}
```

Metoda vrátí číslo pro všechny vstupy, včetně shodných či záporných hodnot.

Ve cvičení opravíš cenu dopravy. Metoda vrací cenu podle částky a způsobu převzetí; výpis zajišťuje `main`. Zkus si před spuštěním odhadnout výsledek těsně pod hranicí dopravy zdarma a přesně na ní.

Metodě už umíme předat [parametry a argumenty](lesson:method-parameters). Teď z ní získáme výsledek.

## Více metod v jednom programu

V Nelině e-shopu má `shipping` na starosti cenu dopravy a `finalPrice` celkovou částku. Díky vrácené hodnotě se mohou o práci rozdělit. Tento program patří do `Main.java`:

```java
public class Main {
    static int shipping(int total, boolean pickup) {
        if (pickup || total >= 1000) {
            return 0;
        }
        return 79;
    }

    static int finalPrice(int total, boolean pickup) {
        return total + shipping(total, pickup);
    }

    public static void main(String[] args) {
        int first = finalPrice(999, false);
        int second = finalPrice(1000, false);
        int third = finalPrice(100, true);
        System.out.println(first);  // 1078
        System.out.println(second); // 1000
        System.out.println(third);  // 100
    }
}
```

Při prvním volání `finalPrice` zavolá `shipping`, dostane 79 a přičte ho k 999. `return` v `shipping` neukončuje `finalPrice` ani celý program; vrací řízení jejímu volajícímu. Při osobním odběru vrací doprava nulu bez ohledu na cenu. Podmínka vyjadřuje dvě samostatné možnosti pomocí `||`.

Příklad počítá s malými nezápornými částkami. Kdyby nákup vyšel záporný nebo se součet nevešel do `int`, museli bychom doplnit další kontrolu. Později může metoda nepřípustný argument odmítnout výjimkou.

## Stejný výsledek lze použít vícekrát

Vrácenou hodnotu můžeš uložit, porovnat nebo předat jiné metodě. `if (shipping(500, false) > 0)` se rozhoduje podle čísla, zatímco metoda, která cenu pouze vypíše, takový výraz neposkytne. Oddělení výpočtu a výpisu umožní [JUnit testy](lesson:testing-overview) bez zachytávání konzole.

Metoda `boolean isAdult(int age) { return age >= 18; }` vrací přímo výsledek porovnání. Není třeba větev „pokud pravda, vrať true, jinak false“. Naopak velmi složité výrazy rozděl do dobře pojmenovaných kroků.

## Boolean ze vstupu ve cvičení

Starter používá `Boolean.parseBoolean(text)`: vrací true pro text `true` bez ohledu na velikost písmen, pro ostatní texty false. Chybný text jako `ano` nevyvolá výjimku. Zadání proto zaručuje vstup true/false; v obecné aplikaci bys musela ostatní texty nejdřív odmítnout.

Před spuštěním změň hranici dopravy na 1500 a ručně přepočítej tři volání. Vysvětli, proč úprava jediné metody změní výsledky všech volajících, ale zachová jejich strukturu.
