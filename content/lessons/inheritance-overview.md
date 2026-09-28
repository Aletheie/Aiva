## Vztah „je druhem“

V evidenci zvířat má pes jméno jako každé jiné zvíře, ale jeho zvuk je konkrétně „haf“. **Dědičnost (inheritance)** dovolí třídě `Dog` převzít dostupné chování z `Animal` a některé metody upravit. Pes je druh zvířete. Knihovna naopak není druh knihy: knihy obsahuje. Takový vztah vyjadřujeme skládáním objektů, ne dědičností.

Než pokračuješ, připomeň si [instanční členy](lesson:static-overview). Dědičnost zde používáme pro chování jednotlivých objektů.

## Konstruktor a přepsaná metoda

Následující tři třídy mohou být spolu v `Main.java`, protože jen `Main` je veřejná:

```java
class Animal {
    private final String name;

    public Animal(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public String sound() {
        return "ticho";
    }
}

class Dog extends Animal {
    public Dog(String name) {
        super(name);
    }

    @Override
    public String sound() {
        return "haf";
    }
}

public class Main {
    public static void main(String[] args) {
        Dog dog = new Dog("Bety");
        System.out.println(dog.getName() + ": " + dog.sound());
    }
}
```

Výstup je `Bety: haf`. `extends Animal` určuje předka. `super(name)` předá jméno konstruktoru předka; v Java 21 ho píšeme jako první příkaz konstruktoru potomka. Konstruktory se nedědí. Bez explicitního volání by překladač zkusil `super()`, ale `Animal` konstruktor bez parametrů nemá.

`Dog` nemá přímý přístup k soukromému `name`; čte ho zděděnou `getName()`. `@Override` je **anotace**, informace pro překladač: zkontroluje, že skutečně přepisujeme dostupnou metodu předka. Překlep `sounds()` by s anotací vyvolal chybu. Při přepsání musí souhlasit název a parametry; návratový typ musí být slučitelný s původním. Metodu také nemůžeš znepřístupnit: z veřejné `sound()` nesmí v potomkovi vzniknout `private sound()`.

## Přepsání a přetížení

**Přepsání (overriding)** nahrazuje zděděnou instanční metodu pro objekt potomka. **Přetížení (overloading)** nabízí stejné jméno s jinými parametry, například `sound(int times)`. Taková metoda nenahradí `sound()`; jsou to dvě různé varianty volání. Soukromou metodu předka nepřepisuješ a statické metody nepoužívají stejný dynamický výběr jako instanční.

Pokud chce potomek využít původní implementaci, může ve své metodě napsat `return super.sound() + " a haf";`. `super.sound()` zde zavolá konkrétně tělo z `Animal`. `this` označuje aktuální objekt, `super` umožňuje obrátit se na předka.

## Kdy dědičnost omezit

`final class Dog` zakazuje další potomky třídy. `public final String getName()` by zakázala přepsání konkrétní metody. Neznamená to automatickou neměnnost celého objektu.

Třída v Javě může dědit z jedné třídy a implementovat více [rozhraní](lesson:interfaces-overview). Dědičnost použij, když potomek dokáže zastoupit předka. Pokud například třída účtu dovoluje vybírat peníze, potomek, který každý výběr odmítne, toto pravidlo porušuje. Samotné ušetření několika řádků kódu proto není dobrý důvod k dědičnosti.

**Skládání objektů (composition)** by vypadalo jako `class Library { private Book book; }`: knihovna má odkaz na knihu a používá její metody. Její veřejné chování nemusí kopírovat celé rozhraní knihy. Knihy není potřeba dědit, aby je knihovna mohla spravovat.

## Procvičení s předpovědí

Přidej `Cat extends Animal` se stejným konstruktorem a `sound()` vracející `mňau`. Nejdřív předpověz výstup pro kočku Mínu, pak spusť. Odstraň `super(name)` a přečti chybu: hledání neexistujícího konstruktoru je problém překladu, ne zvuku za běhu.
