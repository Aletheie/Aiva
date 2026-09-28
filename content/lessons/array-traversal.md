## Jeden prvek za druhým

Jo má za tři dny zapsané 4, 7 a 9 stran. Kolik toho napsala dohromady? Cyklus **for-each (enhanced for)** vezme postupně každou hodnotu z pole a přičte ji k součtu:

```java
int[] values = {4, 7, 9};
int sum = 0;
for (int value : values) {
    sum = sum + value;
}
System.out.println(sum); // 20
```

Čti ho jako „pro každou hodnotu z values“. Proměnná `value` postupně dostane 4, 7 a 9.

U prázdného pole se tělo neprovede. Součet zůstane nula.

## Když potřebuješ index

```java
for (int i = 0; i < values.length; i++) {
    System.out.println(values[i]);
}
```

Zde je správně `<`, ne `<=`. Index roven délce je už za koncem pole.

## Najdi největší hodnotu

U **neprázdného pole** začni `int max = values[0];`. Potom u každé hodnoty ověř, zda je větší, a případně `max` nahraď.

Nezačínej automaticky nulou: v poli `{-8, -3}` bys nesprávně dostala 0. Pro prázdné pole musí zadání určit zvláštní pravidlo, protože žádný největší prvek nemá.

U nejdelší série začátek na nule smysl má. Když sleduješ dny, ve kterých ses šla projít, potřebuješ dvě čísla: kolik dnů trvá současná série a jaká byla nejdelší. Vynechaná procházka ukončí současnou sérii, ale dřívější rekord ti nesmaže.

Pro samotné čtení hodnot je for-each přehlednější. Index použij, když potřebuješ pozici nebo chceš měnit prvky pole.

Při procházení budeme používat [index a délku pole](lesson:arrays) spolu s [cyklem](lesson:loops).

## Větší příklad: statistika teplot

Následující celý program pracuje i s prázdným vstupem:

```java
public class Main {
    static void report(int[] values) {
        if (values.length == 0) {
            System.out.println("Žádná data");
            return;
        }
        int maximum = values[0];
        long sum = 0;
        for (int value : values) {
            sum += value;
            if (value > maximum) {
                maximum = value;
            }
        }
        double average = (double) sum / values.length;
        System.out.println("Maximum: " + maximum);
        System.out.println("Průměr: " + average);
    }

    public static void main(String[] args) {
        report(new int[]{-4, -2, -6}); // Maximum: -2; Průměr: -4.0
        report(new int[0]);          // Žádná data
    }
}
```

První větev skončí přes `return`, takže dál už víme, že první prvek existuje a délka není nula. `long sum` zvětší rozsah součtu proti `int`, ale ani long není neomezený. Cast na double proběhne před dělením. `new int[]{...}` vytváří pole přímo jako argument volání.

## Proč for-each nezmění číselné prvky

`for (int value : values) { value = 0; }` přiřazuje do místní kopie čísla, ne do políčka původního pole. Pro změnu napiš `for (int i = 0; i < values.length; i++) { values[i] = 0; }`. U pole objektů je kopírována reference, takže volání měnící objekt může být na původních datech viditelné; vysvětlí to [předávání hodnotou](lesson:pass-by-value).

## Hotové nástroje Arrays

S `import java.util.Arrays;` lze zavolat `Arrays.toString(values)` pro čitelný text prvků. Samotné `println(values)` místo toho běžně vypíše identifikační popis pole. `Arrays.copyOf(values, values.length)` vytvoří nové pole stejné délky a kopíruje prvky. `Arrays.equals(a, b)` porovná obsahy dvou jednorozměrných polí stejného druhu. `Arrays.sort(values)` pole seřadí **na místě**, proto nejprve kopíruj, pokud chceš původní pořadí zachovat.

Pro řádky různých délek použij vnější for-each nad `int[] row` a vnitřní nad `int value`. Každý řádek tak projdeš přesně do jeho skutečného konce. Vyzkoušej i prázdný vnitřní řádek; vnitřní cyklus se jednoduše neprovede.
