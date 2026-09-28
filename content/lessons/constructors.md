## Údaje hned při vytvoření

Když zakládáš záznam o člověku, chceš mu hned dát jméno. **Konstruktor (constructor)** převezme počáteční údaje při vytváření objektu. Má stejné jméno jako třída a nepíše se před něj návratový typ:

```java
public class Person {
    private String name;

    public Person(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
```

V `this.name = name` se stejný název objevuje dvakrát. Vpravo je jméno, které konstruktor právě dostal v parametru. Vlevo je místo pro jméno v novém záznamu. `this` říká „tento objekt“, takže se předaná hodnota uloží do jeho pole.

## Zavolej metodu konkrétního objektu

```java
Person person = new Person("Ada");
System.out.println(person.getName()); // Ada
```

`getName()` je **instanční metoda (instance method)**. Pracuje s tím objektem, na kterém ji zavoláš. Nemá zde `static`.

`private` znamená, že se k údaji přistupuje jen uvnitř třídy. Navenek je dostupná metoda označená `public`. Podrobnosti patří do zapouzdření.

## Čítač jako druhý příklad

Objekt může mít `private int value;`. Číselný údaj objektu začíná bez vlastního nastavení na `0`. Metoda `increment()` ho zvýší, `reset()` nastaví na nulu a `getValue()` vrátí.

Když třída nemá žádný vlastní konstruktor, Java dodá konstruktor bez parametrů. Dva nové čítače mají každý vlastní hodnotu.

Konstruktor nastavuje počáteční stav [objektu](lesson:objects).

## Úplný příklad s dvěma konstruktory

Tento `Main.java` vytvoří dvě osoby s různými počátečními údaji:

```java
class Person {
    private final String name;
    private int age;

    Person(String name) {
        this(name, 0);
    }

    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    String describe() {
        return name + ": " + age;
    }

    void birthday() {
        age++;
    }
}

public class Main {
    public static void main(String[] args) {
        Person first = new Person("Ada", 20);
        Person second = new Person("Eva");
        first.birthday();
        System.out.println(first.describe());  // Ada: 21
        System.out.println(second.describe()); // Eva: 0
    }
}
```

`new Person("Eva")` v této ukázce znamená jméno Eva a výchozí věk 0. Je to pravidlo napsané v konstruktoru, ne odhad Javy. Pro skutečnou evidenci bys musela rozhodnout, zda smí věk chybět; nula sama o sobě znamená věk nula let. `this(name, 0)` zavolá druhý konstruktor téže třídy. V Java 21 ho píšeme jako první příkaz konstruktoru. Nastavení pak není zkopírované na dvou místech. `this.name` naproti tomu znamená pole aktuálního objektu; závorky tedy rozlišují volání konstruktoru od přístupu k poli.

`final String name` lze při vytvoření nastavit, ale později už ne znovu přiřadit. `age` může měnit `birthday()`. Ukázka přijímá již platné argumenty; [zapouzdření](lesson:encapsulation-overview) doplní kontrolu chybějícího jména a nesmyslných hodnot.

## Kdy implicitní konstruktor zmizí

Jakmile napíšeš libovolný vlastní konstruktor, Java už automaticky nedodá bezparametrický. `new Person()` by zde selhalo při překladu. Pokud ho potřebuješ, musíš napsat smysluplný vlastní. Nenastavuj potichu náhodné údaje jen proto, aby šel objekt vytvořit bez vstupů.

Zápis `void Person(String name)` není konstruktor, ale běžná metoda se zavádějícím názvem. Konstruktor nemá návratový typ ani return s hodnotou. Operace `new` vytvoří objekt a proběhne jeho inicializace; když konstruktor vyvolá výjimku, volající nedostane úspěšně vytvořenou instanci.

Změň výchozí věk v jednomřádkovém konstruktoru na 18. Předpověz, která osoba se změní a proč se druhé volání `new` nadále řídí výslovně předaným věkem.
