## Text nejdřív převeď

Za půjčení vybavení se platí 100 Kč za hodinu. Člověk napíše počet hodin do konzole, ale `nextLine()` vrátí text, třeba `"3"`. Abychom z něj spočítali cenu, nejdřív ho převedeme na číslo. Tomu se říká **parsing**:

```java
Scanner input = new Scanner(System.in);
String line = input.nextLine();
int hours = Integer.parseInt(line.trim());
System.out.println(hours * 100);
```

Tyto řádky patří do `main`; nad třídou musí být `import java.util.Scanner;`.

`trim()` odstraní mezery z okrajů textu. `Integer.parseInt(...)` z něj přečte celé číslo. Pro vstup ` 3 ` program vypíše `300`.

## Více čísel

Další volání `nextLine()` přečte další řádek. Když zadání uvádí dvě čísla na dvou řádcích, čti dvakrát, ve stejném pořadí.

Pro desetinné číslo existuje `Double.parseDouble(...)`; očekává například `2.5` s tečkou.

## Když vstup není číslo

Text `ahoj` na `int` převést nejde. Vznikne chyba `NumberFormatException`. V našich prvních úlohách zadání zaručuje platný číselný vstup. Zachytávání chyb přijde později.

## Proč někdy zmizí další řádek

Ve formuláři nejdřív zadáš věk, stiskneš Enter a pak chceš napsat celé jméno. Pokud program četl věk pomocí `nextInt()`, může za číslem zbýt konec řádku. Následující `nextLine()` ho přečte hned, ještě než jméno napíšeš. Program proto získá prázdný text. Když čteš oba údaje po celých řádcích a věk převedeš zvlášť, tento problém nevznikne.

Při průměrování nezapomeň na desetinné dělení, například `(a + b + c) / 3.0`.

Nejprve čteme [celý řádek pomocí Scanneru](lesson:console-input), potom text převedeme na číslo.

## Metody pro konkrétní rozsah

`Integer.parseInt(text)` vrací `int`, `Long.parseLong(text)` větší celé číslo typu `long` a `Double.parseDouble(text)` hodnotu `double`. Jde o statické metody: nevytváříme objekt `Integer` jen kvůli převodu. Před převodem můžeš odstranit okolní mezery pomocí `trim` nebo `strip`, které podrobně rozebereme u textu.

```java
String raw = " 1200 ";
int amount = Integer.parseInt(raw.trim());
double rate = Double.parseDouble("1.5");
System.out.println(amount * rate); // 1800.0
```

Kód patří do `main` a nevyžaduje Scanner, protože vstup je zde pevný text. `Integer.parseInt("1.5")`, `Integer.parseInt("")` i číslo mimo rozsah `int` vyvolají `NumberFormatException`. `Double.parseDouble("1,5")` desetinnou čárku běžně nepřijme. Čtení čísel závislé na místním formátu je jiné pravidlo než tento převod s tečkou.

## Kdy se hodí nextInt

Když vstup obsahuje pouze čísla oddělená mezerami, může být přímé čtení pohodlné. Ze vstupu `3 4` získají dvě volání `nextInt()` nejprve 3 a pak 4. Scanner tak čte jednotlivé části vstupu, kterým se říká **tokeny (tokens)**. Podobně `nextDouble()` čte desetinné číslo podle nastaveného místního formátu.

Kurz proto obvykle čte celý řádek a pak ho převádí. `input.hasNextInt()` by umělo předem ověřit další číselný token, ale směšování dvou způsobů čtení není nutné pro základní úlohy. Pro neplatný vstup se naučíme [try/catch](lesson:exceptions-overview).

## Parsing není úplná validace

Vstup `-3` lze správně převést na celé číslo, ale jako počet cestujících je nepřípustný. Nejdřív ověř syntaxi čísla a potom pravidlo aplikace. U desetinných vstupů může `Double.isFinite(value)` odmítnout zvláštní hodnoty NaN a nekonečno; vrací true právě pro konečnou hodnotu.

Pro dvě částky na dvou řádcích zkontroluj, že čteš opravdu dvakrát. Vypiš jejich součet až po převodu obou hodnot: texty `"10" + "20"` by vytvořily `"1020"`, nikoli 30.
