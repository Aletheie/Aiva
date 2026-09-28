## Proč součet nevypadá jako na účtence

```java
System.out.println(0.1 + 0.2);
```

Java s typem `double` vypíše `0.30000000000000004`. Není to překlep. Některé desetinné hodnoty nejdou v jeho vnitřním zápisu uložit přesně.

## Kdy to řešit

Pro běžnou ukázku vzdálenosti nebo průměru je `double` užitečný. U přesných částek v penězích ale nechceme, aby se takové odchylky hromadily.

U dvou položek za 19,90 Kč a 10 Kč můžeš místo korun ukládat celé haléře: 1990 a 1000. Součet pak počítáš stejně jako počet kusů ve skladu, bez desetinné části:

```java
int firstPrice = 1990;
int secondPrice = 1000;
System.out.println(firstPrice + secondPrice); // 2990 haléřů
```

Vždy si poznamenej jednotku. Číslo `1990` zde znamená 19,90 Kč, ne 1990 Kč.

Pro složitější desetinné výpočty existuje `BigDecimal`; jeho malý příklad najdeš níže. Volba typu závisí na tom, jak přesný výsledek potřebuješ.

## Přesný součet a přetečení

Pro větší částky v celých haléřích použij `long`. Například `long cents = 1990L + 1000L;` představuje 29,90 Kč. `Math.addExact(a, b)` vrátí součet dvou celých čísel stejné velikosti, ale při přetečení vyvolá `ArithmeticException`. Obyčejné `a + b` se naopak může tiše přetočit. Program pak musí na chybu reagovat, například odmítnout částku, která je pro jeho evidenci příliš velká.

## Přesná desetinná čísla s BigDecimal

Nad třídu vlož `import java.math.BigDecimal;` a následující kód do `main`:

```java
BigDecimal first = new BigDecimal("0.1");
BigDecimal second = new BigDecimal("0.2");
BigDecimal total = first.add(second);
System.out.println(total.toPlainString()); // 0.3
```

`BigDecimal` uchovává desetinné číslo s volitelnou přesností. Konstruktor z textu zachová přesnou desetinnou hodnotu; konstruktor z `double` by mohl převzít jeho binární odchylku. `add` vrací nový součet, původní objekty nemění. `toPlainString()` vrací text bez exponenciálního zápisu.

Pro dělení může být nutné pravidlo zaokrouhlení. S importem `java.math.RoundingMode` výraz `new BigDecimal("10").divide(new BigDecimal("3"), 2, RoundingMode.HALF_UP)` vrátí 3.33. Argument 2 je počet desetinných míst a HALF_UP zaokrouhluje k nejbližší hodnotě, při přesné půlce směrem od nuly.

`compareTo` porovnává číselnou hodnotu: `new BigDecimal("1.0").compareTo(new BigDecimal("1.00"))` vrátí 0. `equals` bere v úvahu i měřítko, takže zde vrátí false. Volbu jednotky, přesnosti a pravidla zaokrouhlení vždy pojmenuj v zadání; samotný typ ji za tebe nerozhodne.
