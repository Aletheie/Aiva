## Dvě varianty pozdravu

Přihlášenou návštěvnici pozdravíš jménem, ostatním stačí obecné „Ahoj“. Obě varianty dělají stejnou práci, jen jedna potřebuje navíc jméno. Metody proto mohou mít společný název a lišit se parametry. Tomu se říká **přetěžování (overloading)**:

```java
static String greeting() {
    return "Ahoj!";
}

static String greeting(String name) {
    return "Ahoj, " + name + "!";
}
```

`greeting()` vybere první variantu. `greeting("Ada")` druhou. Java se rozhodne podle argumentů ve volání.

## Kdy to pomůže

Když obě varianty dělají stejný druh práce a liší se jen vstupy. Třeba pozdrav s konkrétním jménem a bez jména.

Pouhý jiný návratový typ nestačí. Nemůžeš mít vedle sebe `int size()` a `String size()` se stejnými parametry.

Nedávej stejné jméno metodám s nesouvisejícím významem. Dobře zvolený název je důležitější než využití nového zápisu.

## Výběr podle typů při překladu

Celý `Main.java` ukazuje dvě varianty součtu:

```java
public class Main {
    static int add(int a, int b) {
        return a + b;
    }

    static double add(double a, double b) {
        return a + b;
    }

    public static void main(String[] args) {
        System.out.println(add(2, 3));     // 5
        System.out.println(add(2.0, 3));   // 5.0
        System.out.println(add(2.5, 3.5)); // 6.0
    }
}
```

První volání má dva `int`, takže vybere celočíselnou variantu. Druhé obsahuje `double`; druhý argument se může rozšířit na `double` a vybere se druhá metoda. Překladač tedy pro `2.0` vybere desetinnou variantu, i když má číslo za tečkou jen nulu. Rozhoduje typ `double`, který zná při překladu.

Přetížení nezaměňuj s [přepsáním zděděné metody](lesson:inheritance-overview). Při přepsání rozhoduje skutečný objekt za běhu; přetížené varianty mají různé parametry. Pokud dvě dostupné varianty vyhovují stejně a žádná není vhodnější, může být volání nejednoznačné.

## Rozšíření: rekurze

**Rekurze** znamená, že metoda volá sama sebe pro menší podproblém. Do třídy, mimo `main`, lze přidat:

```java
static int sumTo(int n) {
    if (n == 0) {
        return 0;
    }
    return n + sumTo(n - 1);
}
```

Pro nezáporné malé `n` volání `sumTo(3)` rozvine 3 + 2 + 1 + 0 a vrátí 6. Podmínka pro nulu je **základní případ**, který další volání zastaví. Záporný vstup by se dalším odečítáním od nuly vzdaloval, takže ho tato ukázka nepřijímá. Pro velké `n` hrozí přetečení součtu i přeplnění zásobníku volání; cyklus je pro tuto úlohu praktičtější. Jednotlivá volání rozepíšeme v samostatné [dobrovolné lekci o rekurzi](lesson:recursion).
