## Parametr dostává kopii

Java při volání metody kopíruje hodnotu argumentu. Říká se tomu **předávání hodnotou (pass by value)**:

```java
static void increment(int number) {
    number++;
}
```

Když zavoláš `increment(count)` pro `count = 3`, mění se jen místní `number`. Původní `count` zůstane `3`.

## U objektu se kopíruje odkaz

Představ si třídu `Box` s údajem `int value`:

```java
static void setToNine(Box box) {
    box.value = 9;
}
```

Parametr má kopii odkazu na **stejný objekt**. Je to podobné, jako když někomu pošleš odkaz na společný dokument: odkazy máte dva, dokument zůstává jeden. Když ho druhá osoba upraví, změnu uvidíš i ty. Stejně se zde projeví změna `value`.

Kdyby metoda napsala `box = new Box();`, změnila by jen svůj místní odkaz. Podobně si příjemce může uložit odkaz na jiný dokument, ale tvůj původní odkaz tím nepřepíše.

## Pole je také objekt

Po `int[] copy = original;` obě proměnné odkazují na stejné pole. Nevznikla kopie jeho prvků.

Pro oddělenou kopii vytvoř `new int[original.length]` a prvky přenes cyklem. U polí porovnání `==` ověřuje, zda oba odkazy míří na tentýž objekt, ne shodu obsahu.

Při nejistotě si nakresli dvě jména a šipky k objektům. Zjisti, jestli měníš šipku, nebo údaj uvnitř objektu.

Připomeň si, co ukládá [reference na objekt](lesson:objects), a jak fungují [parametry metody](lesson:method-parameters).

## Změna objektu a změna reference vedle sebe

V tomto `Main.java` metoda `mutate` mění obsah původního objektu a `replace` si vytvoří jiný objekt:

```java
class Box {
    int value;
}

public class Main {
    static void mutate(Box box) {
        box.value = 9;
    }

    static void replace(Box box) {
        box = new Box();
        box.value = 100;
    }

    public static void main(String[] args) {
        Box original = new Box();
        original.value = 3;
        mutate(original);
        System.out.println(original.value); // 9
        replace(original);
        System.out.println(original.value); // stále 9
    }
}
```

Po `mutate(original)` přečteš z původního objektu 9, protože metoda změnila jeho pole. `replace(original)` si pak vytvoří nový box s hodnotou 100, ale uloží ho pouze do svého parametru `box`. Proměnná `original` stále ukazuje na box s devítkou. Po návratu z `replace` už na nový box žádná proměnná z této ukázky neodkazuje.

Proto není přesné říkat „objekty se v Javě předávají referencí“. Předává se **hodnota reference**, tedy její kopie. Kdyby šlo měnit proměnnou volajícího referenčním předáním, `replace` by ji přesměrovalo; to se nestalo.

## Jak vrátit náhradu správně

Napiš metodu `static Box createBox(int value) { Box box = new Box(); box.value = value; return box; }`. Volající pak vědomě provede `original = createBox(100);`. Návratová hodnota jasně ukazuje, že jde o nový objekt, a přiřazení mění právě proměnnou volajícího.

## Mělká kopie není hluboká kopie

Kopie pole čísel vytváří nezávislá políčka s čísly. Kopie pole `Box[]` zkopíruje odkazy, takže obě pole stále ukazují na stejné boxy. To je **mělká kopie (shallow copy)**: dvě pole, ale společné boxy uvnitř. **Hluboká kopie (deep copy)** vytvoří i samostatné vnitřní objekty. Než ji napíšeš, rozhodni, co všechno má být nezávislé; například kopie seznamu rezervací nemusí znamenat také kopii každé knihy v katalogu.

Pro dva odkazy na stejný Box předpověz změnu `value`, potom jeden odkaz přesměruj na `new Box()`. Při každém kroku si řekni, zda měníš políčko uvnitř objektu, nebo samotnou šipku.

> [!OPTIONAL] Pod povrch: proč nelze vyměnit cizí proměnné
>
> Pokus `static void swap(Box a, Box b) { Box temp = a; a = b; b = temp; }` vymění jen dvě místní hodnoty reference. Proměnné volajícího nejsou adresy předané k přepsání. Aby volající použil jiné objekty, musí přijmout návratovou hodnotu nebo změnu zapsat do výslovně předané měnitelné struktury.
>
> Stejná pravidla platí pro čísla, reference na pole i String. String pouze nedovoluje změnu svého obsahu, takže snadno vznikne mylný dojem jiného způsobu předávání. Rozdíl je v měnitelnosti objektu, ne v mechanismu předání argumentu.
