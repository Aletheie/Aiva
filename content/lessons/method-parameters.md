## Pozdrav pro různé lidi

Text pozdravu může zůstat stejný, zatímco jméno hosta se mění. V metodě si pro něj připravíš **parametr (parameter)**: pojmenovaný vstup, který se naplní při volání.

```java
static void greet(String name) {
    System.out.println("Ahoj, " + name + "!");
}
```

V `main` ji můžeš zavolat:

```java
greet("Ada");
greet("Ema");
```

Vypíše `Ahoj, Ada!` a `Ahoj, Ema!`. Konkrétní hodnotě ve volání, třeba `"Ada"`, říkáme **argument (argument)**.

## Na pořadí argumentů záleží

Metoda může mít více parametrů oddělených čárkou:

```java
static void showTotal(int count, int price) {
    System.out.println(count * price);
}
```

Volání `showTotal(3, 80)` předá do `count` trojku a do `price` osmdesát. Počet, pořadí a typy hodnot musí odpovídat zápisu metody.

## Kde platí názvy parametrů

`count` a `price` jsou dostupné jen v těle `showTotal`. Tomuto rozsahu platnosti říkáme **scope**. Nemusí se jmenovat stejně jako proměnné v `main`.

Zatím metoda výsledek vypisuje. V další lekci ho předá zpět pomocí `return`.

Pokud si nejsi jistá deklarací a voláním, vrať se k [první metodě](lesson:methods).

## Parametr je místní jméno vstupu

Celý program ukazuje pořadí předávání:

```java
public class Main {
    static void showPrice(String label, int price) {
        System.out.println(label + ": " + price + " Kč");
    }

    public static void main(String[] args) {
        String product = "Kniha";
        int amount = 120;
        showPrice(product, amount);
        showPrice("Kurz", 200 + 50);
    }
}
```

`label` a `price` jsou **parametry**, jména v deklaraci. `product`, `amount`, `"Kurz"` a výraz `200 + 50` jsou **argumenty**, konkrétní hodnoty při volání. Při druhém volání se výraz nejdřív spočítá na 250 a teprve potom předá. Výstup je `Kniha: 120 Kč` a `Kurz: 250 Kč`.

Je to podobné jako vyplnění dvou polí formuláře: do prvního patří popisek, do druhého cena. Java hodnoty přiřadí podle pozice; nezkoumá, jak se proměnné u volajícího jmenují. `showPrice(amount, product)` by neprošlo kontrolou typů. Java při běžném volání nemá pojmenované argumenty jako některé jiné jazyky.

## Každé volání má vlastní lokální hodnoty

Parametry jsou dostupné jen v těle daného volání. Pokud `showPrice` přiřadí `price = 0`, změní pouze místní kopii čísla; `amount` v `main` zůstane 120. Stejně vznikají lokální proměnné uvnitř metody při každém volání znovu. Zásobník těchto volání uvidíš později v debuggeru.

Počet a typy parametrů patří k podpisu metody. Jména vol tak, aby vyjadřovala význam: `showPrice(String label, int price)` se používá snáze než `f(String a, int b)`. Příliš mnoho parametrů může naznačovat, že operace řeší několik různých věcí; později je můžeš seskupit do objektu.

Přidej třetí volání s jiným produktem a předpověz jeho výstup. Pak zkus jednu změnu počtu argumentů a přečti překladovou chybu. Porovnej hlášení s počtem parametrů v hlavičce metody: ukazuje, který vstup jí při volání chybí nebo přebývá.
