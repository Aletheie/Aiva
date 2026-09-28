## Jeden postup pro více typů

Potřebuješ uchovat jednu hodnotu a později ji přečíst. Jednou je to jméno, podruhé počet lístků. Místo dvou téměř stejných tříd napíšeme `Box<T>` a konkrétní typ doplníme při použití. Tomu se říká **generika (generics)**. `Box<String>` přijme text a při čtení také vrátí text. Znaky `<` a `>` v zápisu `<String>` ohraničují typový argument; neporovnáváme zde čísla.

Navazuješ na [třídy a objekty](lesson:objects). `T` je konvenční jméno typového parametru, ne název další povinné třídy.

## Vlastní generická třída

Celý program ulož do `Main.java`:

```java
class Box<T> {
    private T value;

    public Box(T value) {
        this.value = value;
    }

    public T get() {
        return value;
    }

    public void set(T value) {
        this.value = value;
    }
}

public class Main {
    public static void main(String[] args) {
        Box<String> name = new Box<>("Ada");
        name.set("Eva");
        String text = name.get();
        Box<Integer> count = new Box<>(3);
        int result = count.get() + 1;
        System.out.println(text);   // Eva
        System.out.println(result); // 4
    }
}
```

Při použití `Box<String>` se `T` pro kontrolu typů chápe jako `String`; `get()` tedy vrací text a `set(...)` text vyžaduje. `name.set(7)` by neprošlo překladem. Zápis `<>` u konstruktoru, zvaný **diamond**, nechává překladač odvodit typové argumenty z kontextu. Neznamená libovolný měnící se typ.

## Proč Integer místo int

Typové argumenty musí být referenční typy. Primitivnímu `int` odpovídá obalový typ `Integer`, typu `double` odpovídá `Double` a typu `boolean` odpovídá `Boolean`. Automatický převod `3` na `Integer` je **autoboxing**. Převod výsledku `count.get()` zpět pro sčítání je **unboxing**.

Obal může obsahovat `null`; rozbalení takové hodnoty do `int` vyvolá `NullPointerException`. `Integer` hodnoty porovnávej přes `equals`, protože `==` u dvou referencí porovnává totožnost. Některé malé hodnoty jsou sdílené, takže chybné použití `==` může zdánlivě fungovat.

## Generická metoda a omezení typu

Do třídy `Main`, mimo `main`, lze přidat:

```java
static <T> T identity(T value) {
    return value;
}

static <T extends Number> double twice(T value) {
    return value.doubleValue() * 2;
}
```

`<T>` před návratovým typem zavádí parametr této metody. `identity("Ahoj")` vrací text, `identity(5)` obalené číslo. `extends Number` je **horní mez typu (type bound)**: dovolí například `Integer` nebo `Double`, ale ne `String`. `Number.doubleValue()` převede číselný objekt na `double`; `twice(2.5)` dá `5.0`. Nemusí jít o bezeztrátový převod libovolně velkého čísla.

## Wildcard pro práci s různými typy

`Box<Integer>` není podtypem `Box<Number>`. Kdyby byl, šlo by do krabičky celých čísel přes širší typ vložit desetinné číslo. Pro pružnější čtení lze použít **wildcard**, tedy otazník:

```java
static double readNumber(Box<? extends Number> box) {
    return box.get().doubleValue();
}
```

Metoda přijme `Box<Integer>` i `Box<Double>`. Ví, že lze číst `Number`, ale neví přesný typ pro bezpečné `set(3)`. `Box<?>` znamená neznámý typ, ze kterého lze obecně číst `Object`. Opačná mez `? super Integer` dovoluje zapisovat `Integer`, ale čtený výsledek znáš jen jako `Object`. Pomůcka **PECS**: producent dat `extends`, konzument dat `super`. Pro první seznamy ti stačí konkrétní `List<String>`.

## Typová kontrola není validace hodnot

`Box<String>` odmítne číslo 7, ale text `""` do něj uložit lze. Překladač hlídá druh hodnoty, ne to, zda někdo vyplnil jméno. Kontrolu prázdného jména musíš napsat zvlášť. Typové argumenty jsou při překladu převážně odstraněny, čemuž se říká **type erasure**. Proto například nelze napsat `new T()` bez další informace o vytváření objektu.

Vyzkoušej `Box<Boolean>` a vyvolej záměrnou chybu `set("ano")`. Přečti, jaký typ překladač požadoval. Pak oprav hodnotu na `true` a pokračuj ke [kolekcím](lesson:collections-overview), kde generika používáme neustále.

> [!OPTIONAL] Pod povrch: type erasure a boxing
>
> Typový parametr pomáhá zejména překladači. Běžné `List<String>` a `List<Integer>` za běhu nepředstavují dvě samostatně vygenerované třídy ArrayList. Informace o argumentech se při překladu převážně maže a překladač na potřebná místa vloží kontroly nebo převody referencí.
>
> Proto `value instanceof List<String>` obecně není dovolená runtime kontrola. `value instanceof List<?>` ověří seznam, ale jeho prvky musíš kontrolovat zvlášť. Neparametrizovaný **raw type** `List` tuto typovou ochranu oslabí a může posunout chybu až na běh.
>
> `List<Integer>` obsahuje reference na číselné objekty; `int[]` obsahuje primitivní prvky. Boxing může mít paměťové a výkonnostní náklady. Pro první úlohy vybírej podle potřebných operací: pevný počet čísel může zůstat v `int[]`, průběžně rostoucí seznam se lépe spravuje přes `List<Integer>`. Paměťové náklady porovnej měřením, až na nich bude v konkrétním programu záležet.
