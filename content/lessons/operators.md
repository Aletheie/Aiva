## Znaménka, která počítají

**Operátory (operators)** `+`, `-`, `*` a `/` sčítají, odčítají, násobí a dělí.

```java
System.out.println(2 + 3 * 4);   // 14
System.out.println((2 + 3) * 4); // 20
```

Násobení a dělení mají přednost před sčítáním. Závorkami pořadí změníš nebo zpřehledníš.

## Dělení a zbytek

Při dělení dvou celých čísel se desetinná část zahodí. Znak `%` vrátí **zbytek po dělení (remainder)**:

```java
int seconds = 125;
System.out.println(seconds / 60); // 2 celé minuty
System.out.println(seconds % 60); // 5 sekund navíc
```

Skladba dlouhá 125 sekund tak trvá dvě celé minuty a ještě pět sekund. Dělení určí počet celých minut, `%` to, co se už do další celé minuty nevejde. Stejně můžeš rozdělit 14 baterií do sad po čtyřech: vzniknou tři sady a dvě baterie zbudou. `%` tu neznamená procenta.

## Text a čísla

`+` připojuje také text. Výpočet dej do závorek:

```java
System.out.println("Součet: " + (2 + 3)); // Součet: 5
```

Bez závorek by se zleva připojila nejprve dvojka a potom trojka: `Součet: 23`.

Teď stačí několik malých výpočtů. Desetinné dělení si v další lekci vyzkoušíš zvlášť.

## Celá čísla se nepočítají jako desetinná

Zkus v `main` vypsat `7 / 3`, `7 % 3`, `-7 / 3` a `-7 % 3`. Výsledky jsou 2, 1, -2 a -1. Celočíselné dělení odřezává směrem k nule a zbytek má znaménko děleného čísla. Proto pro lichost obecného čísla používej `number % 2 != 0`, ne jen porovnání zbytku s jedničkou.

Celé dělení nulou vyvolá `ArithmeticException`. U `double` se může objevit `Infinity` nebo `NaN`, například `1.0 / 0.0` a `0.0 / 0.0`. Při dělení účtu mezi nula lidí ti ani jedna z těchto hodnot neřekne, kolik má kdo zaplatit. Takový vstup je potřeba před výpočtem odmítnout.

## Čitelné pořadí operací

```java
int price = 120;
int count = 3;
int discount = 20;
int total = price * count - discount;
System.out.println(total); // 340
System.out.println(2 + 3 + " Kč"); // 5 Kč
System.out.println("Kč " + 2 + 3); // Kč 23
```

Násobení proběhne před odčítáním. U `+` s textem se výrazy vyhodnocují zleva, takže záleží, kdy poprvé vznikne text. Závorkami můžeš přímo ukázat, že se mají nejdřív sečíst částky a teprve pak připojit jednotka. Unární minus v `-price` mění znaménko jedné hodnoty; `price - discount` odčítá dvě hodnoty.

## Změna hodnoty

`count += 2` je pro náš `int` stručná aktualizace o dvě, `count++` o jednu a `count--` snížení o jednu. U samostatného příkazu můžeš psát `++count` i `count++`; uvnitř výrazu ale první vrací novou a druhý původní hodnotu. Začátečnický kód je čitelnější, když zvýšení oddělíš na vlastní řádek.

Pro čas 3671 sekund vypočti hodiny `seconds / 3600`, minuty `(seconds % 3600) / 60` a sekundy `seconds % 60`. Očekávej 1 hodinu, 1 minutu a 11 sekund. Ke každému zbytku uměj říct, čeho je to zbytek.
