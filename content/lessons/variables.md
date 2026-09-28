## Hodnota se jménem

Enid kupuje lístky na studentské promítání v Nevermore. V této ukázce stojí jeden 80 Kč a potřebuje tři. Počet si uložíme do **proměnné (variable)**: hodnoty, které dáme jméno, abychom ji mohli použít ve výpočtu.

```java
int count = 3;
int total = count * 80;
System.out.println(total);
```

`int` znamená celé číslo, `count` je název proměnné pro počet lístků a `3` její počáteční hodnota. Hvězdička `*` násobí. Do `total` se uloží cena tří lístků: `240`.

## Změna hodnoty

Wednesday se nakonec přidá. Počet lístků proto změníme na čtyři:

```java
count = 4;
System.out.println(total); // stále 240
```

Znak `=` znamená **přiřazení (assignment)**: nejdřív se spočítá pravá strana, potom se hodnota uloží vlevo. Typ píšeš při založení proměnné, při změně už ne.

V `total` ale pořád leží dříve vypočtených 240 Kč. Je to jako částka napsaná na lístku: když změníš počet hostů v seznamu, napsané číslo se samo nepřepíše. Pro novou cenu proveď `total = count * 80;` ještě jednou; teď dostaneš 320.

## Názvy a výměna hodnot

Vol popisné názvy, například `bookPrice`. Bez mezer, obvykle s malým písmenem na začátku. Text za `//` je komentář pro člověka.

Při výměně dvou hodnot si jednu nejdřív odlož:

```java
int spare = left;
left = right;
right = spare;
```

Bez `spare` by první přiřazení původní hodnotu `left` ztratilo. Proměnné před použitím vytvoř a naplň.

Proměnné uchovají data, se kterými pracuje [algoritmus](lesson:language-and-algorithms).

## Deklarace, inicializace a přiřazení

Tyto pojmy popisují tři různé kroky. **Deklarace** zavede proměnnou a její typ, **inicializace** jí dá první hodnotu, **přiřazení** může později hodnotu změnit. V `main` můžeš napsat:

```java
int count;       // deklarace
count = 3;       // první přiřazení, inicializace
count = count + 2;
System.out.println(count); // 5
```

Pravá strana používá staré `count`, pak se výsledek uloží do stejné proměnné. Příkaz `count = count + 2` tedy čti jako „k dosavadnímu počtu přidej dva a zapamatuj si nový počet“. Lokální proměnnou musíš před čtením naplnit; překladač nedovolí výpis dosud nepřiřazeného `count`.

## Sleduj hodnotu po každém řádku

```java
int left = 4;
int right = 9;
int spare = left;
left = right;
right = spare;
System.out.println(left + ", " + right); // 9, 4
```

Po třetím řádku je `spare == 4`. Po čtvrtém jsou `left` i `right` rovny 9, ale původní čtyřka se neztratila díky pomocné proměnné. Poslední přiřazení ji uloží do `right`. Kopírování čísel nevytváří trvalé propojení proměnných.

## Neměnné přiřazení a názvy

`final int seats = 30;` zakazuje pozdější přiřazení do `seats`. Není to totéž co `static`: sdílení mezi objekty přijde později. Používej názvy vysvětlující význam a jednotku, například `durationMinutes`, ne neurčité `x`. Jméno nesmí být klíčové slovo jako `class` a rozlišuje velikost písmen.

Zkus cenu dvou lístků: nejprve `ticketCount = 2`, `price = 120`, `total = ticketCount * price`. Změň počet na tři a vysvětli, proč se uložené `total` musí přepočítat dalším přiřazením. Očekávej nejprve 240, potom 360.

> [!OPTIONAL] Pod povrch: kdy se výsledek přepočítá
>
> Lokální proměnné a parametry lze v modelu JVM chápat jako hodnoty uložené v rámcích volání. `int total = count * 80` nejdřív načte aktuální count, vynásobí a uloží výsledek. Neuloží matematický vztah, který by později sledoval count.
>
> ```java
> int count = 2;
> int total = count * 80;
> count = 5;
> System.out.println(total); // 160
> ```
>
> JIT může některé hodnoty držet v registrech nebo výpočet optimalizovat. Pravidla jazyka ale musí zůstat stejná. Přirovnání ke krabičce pomáhá pochopit přiřazení. Neříká ale, kde JVM hodnotu skutečně uloží.
