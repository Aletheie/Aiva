## Proč 5 / 2 není 2.5?

Pět jablek rozdělíš mezi dva lidi po dvou celých kusech a jedno zbude. Když dovolíš jablko rozpůlit, každý dostane dvě a půl. Java také rozlišuje dělení celých a desetinných čísel. V prvním řádku jsou obě čísla celá:

```java
double first = 5 / 2;    // 2.0
double second = 5 / 2.0; // 2.5
```

V prvním řádku se nejdřív spočítá `2` a až potom uloží do `double`. Desetinnou část už zpět nezískáme.

## Převeď hodnotu před výpočtem

```java
int chapters = 7;
int days = 2;
double average = (double) chapters / days; // 3.5
```

Sedm kapitol za dva dny je průměrně 3,5 kapitoly denně. Zápis `(double)` převede `chapters` na desetinné číslo ještě před dělením. Tomuto výslovnému převodu říkáme **přetypování (casting)**. Nemění počet přečtených kapitol; mění způsob, jakým s ním výpočet zachází.

Opačný převod `(int) 12.9` dá `12`. Desetinnou část **odřízne**, nezaokrouhlí na nejbližší celé číslo.

## Když je celé číslo velké

Pro tři miliardy nestačí `int`. Použij `long` a na konec číselného zápisu přidej `L`:

```java
long visitors = 3000000000L;
```

Výsledek vždy zkontroluj na malých číslech, která umíš spočítat i bez programu. Chybu typu tak uvidíš rychleji.

Výpočty používají [aritmetické operátory](lesson:operators). Teď uvidíš, jak jejich výsledek závisí na typu čísla.

## Automatické rozšíření a zúžení

Při `int small = 12; long large = small;` se hodnota rozšíří automaticky a přesně. Opačný směr `int back = (int) large;` vyžaduje explicitní cast, protože obecný `long` se do `int` nemusí vejít. Přetypování není kontrola rozsahu: `(byte) 130` skončí hodnotou -126.

Převod `int` na `double` je přesný, ale některá velká `long` čísla už `double` nerozliší. To, že je převod automaticky dovolený, tedy neznamená záruku zachování všech číslic pro každou dvojici typů. `var value = 5 / 2` odvodí `int`, protože takový je výsledek výrazu.

## Typ potřebuješ opravit před operací

```java
int a = 2_000_000_000;
int b = 2_000_000_000;
long wrong = a + b;
long correct = (long) a + b;
System.out.println(wrong);   // -294967296
System.out.println(correct); // 4000000000
```

První součet přeteče jako `int` a až potom se rozšíří na `long`. Druhý rozšíří první operand před sčítáním, takže se i celá operace provede jako `long`. Podtržítka v číselném literálu jsou pouze oddělovače pro čtenáře.

## Číselný převod a parsing nejsou totéž

`(int) 12.9` převede číselnou hodnotu na 12. `Integer.parseInt("12")` interpretuje text jako zápis čísla. `String.valueOf(12)` jde opačně a vrátí text `"12"`. Nelze zapsat `(int) "12"`, protože text není číslo čekající na zúžení.

Pro záporné desetinné číslo `(int) -12.9` dostaneš -12, tedy stále odříznutí směrem k nule. Pokud požadavek říká zaokrouhlit, potřebuješ konkrétní pravidlo a metodu, například `Math.round`; rozebereme ji v [užitečné matematice](lesson:useful-math).

Spočítej průměr dvou celých známek 1 a 2 dvěma způsoby: `(a + b) / 2` a `(a + b) / 2.0`. Vysvětli výsledky 1 a 1,5 ještě před spuštěním. Pozor, výpis v Javě použije desetinnou tečku.

> [!OPTIONAL] Pod povrch: proč double neudrží každé číslo
>
> Double používá binární plovoucí řádovou čárku: znaménko, exponent a významové číslice. Některé desetinné zlomky mají v dvojkové soustavě nekonečný rozvoj, stejně jako 1/3 v desítkové. Ukládá se nejbližší reprezentovatelná hodnota, ne libovolně dlouhý přesný zlomek.
>
> ```java
> double first = 9_007_199_254_740_992d;
> System.out.println(first == first + 1); // true
> ```
>
> Písmeno `d` výslovně označí double literál. V této velikosti je mezera mezi některými sousedními hodnotami větší než jedna, takže přičtení jedničky nemusí změnit uložený výsledek. Více desetinných míst ve výpisu ztracenou přesnost nevrátí. Pro přesná celá čísla používej celočíselný typ v jeho rozsahu, pro přesný desetinný model například BigDecimal.
