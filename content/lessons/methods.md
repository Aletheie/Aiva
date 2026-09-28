## Vlastní pojmenovaný krok

**Metoda (method)** sdružuje příkazy pod jedním názvem. Můžeš ji spustit vícekrát:

```java
public class Main {
    static void greet() {
        System.out.println("Ahoj");
    }

    public static void main(String[] args) {
        greet();
        greet();
    }
}
```

Výstup jsou dva řádky `Ahoj`. Zápisu `greet();` říkáme **volání metody (method call)**.

## Kde metodu napsat

Metoda `greet` je uvnitř třídy `Main`, ale **mimo metodu `main`**. Metody nevkládáme do sebe. Sleduj páry složených závorek.

`void` říká, že metoda nevrací výsledek. Může ale něco udělat, například vypsat text.

`static` tu umožní volat metodu přímo z `main`, bez vytváření objektu. Podrobnosti přijdou později.

## Malý úkol, jasné jméno

Metoda by měla dělat jednu srozumitelnou věc. Lepší název než `doStuff` je třeba `printMenu`.

Samotné napsání metody ji nespustí. Program do jejího těla vstoupí až při volání a pak se vrátí k dalšímu příkazu.

Metoda může pojmenovat i postup, který obsahuje [cyklus](lesson:loops).

## Stejné menu na dvou místech

Dustinova textová hra potřebuje menu při spuštění i po návratu z herní místnosti. Výpis proto napíšeme jednou do `showMenu` a na obou místech metodu zavoláme. Celý program:

```java
public class Main {
    static void showMenu() {
        System.out.println("1 - Nová hra");
        System.out.println("0 - Konec");
    }

    public static void main(String[] args) {
        showMenu();
        System.out.println("Vyber možnost");
        showMenu();
    }
}
```

Nejdřív se zavolá `main`, ta zavolá `showMenu`, po jejím skončení pokračuje následujícím řádkem a později ji zavolá znovu. Menu se tedy vypíše dvakrát. Na umístění deklarace nad nebo pod `main` nezáleží.

## Co zjistíš z hlavičky metody

`static void showMenu()` znamená metodu třídy, bez návratové hodnoty, jménem showMenu a bez parametrů. Kulaté závorky při volání musí zůstat i tehdy, když nic nepředáváš. Metoda s `void` může použít samotné `return;` pro předčasné ukončení, ale nemůže vrátit číslo jako výsledek.

`static` tady umožňuje přímé volání ze statické `main`. U objektů se později naučíš instanční metody, které pracují se stavem konkrétní věci. Není pravidlem, že všechny metody v Javě mají být statické.

## Oprava menu na jednom místě

Když Dustin přidá do menu „Nápověda“, upraví pouze `showMenu`. Nová položka se pak objeví při každém jejím volání. Kdyby měl výpisy zkopírované na dvou místech, snadno by opravil jen jedno. Rozdělení programu na pojmenované části se označuje také jako **modularizace (modularization)**. Metodu pro menu přitom nech pouze vypisovat menu; ukládání hry má jiný účel.

Vezmi opakované dva výpisy a přesuň je do metody. Nejdřív zkontroluj, že se výstup nezměnil. Potom uprav jeden řádek menu a ověř obě volání. První změna byla refaktoring, druhá změna chování; je užitečné je rozlišovat.

> [!OPTIONAL] Pod povrch: rámec volání a zásobník
>
> Každé aktivní volání metody má v modelu JVM svůj **rámec (frame)** s lokálními hodnotami a pracovním zásobníkem. Když main zavolá showMenu, vznikne další rámec. Po návratu se z něj řízení vrátí k místu volání. Dvě volání téže metody proto mohou mít různé hodnoty stejně pojmenovaných parametrů.
>
> Při rekurzi je rámců více současně. Nekončící nebo příliš hluboké volání může vyčerpat zásobník a vyvolat StackOverflowError. Cyklus s jedním rámcem tímto způsobem zásobník neprohlubuje. JIT může některá volání vložit přímo do volající metody, což se nazývá **inlining**; pozorované chování přitom musí odpovídat pravidlům Javy.
