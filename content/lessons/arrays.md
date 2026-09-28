## Jedno jméno, několik hodnot

Jo si zapisuje, kolik stran rukopisu napsala během tří dnů: první den čtyři, druhý sedm a třetí devět. Místo tří oddělených proměnných použijeme **pole (array)**. To drží pevný počet hodnot stejného typu:

```java
int[] pages = {4, 7, 9};
```

Zápis `int[]` znamená „pole celých čísel“. `pages` obsahuje tři prvky.

## Počítáme od nuly

Pořadové číslo prvku se nazývá **index**:

```java
System.out.println(pages[0]);     // 4
System.out.println(pages[2]);     // 9
System.out.println(pages.length); // 3
```

První den tedy najdeš pod indexem 0, druhý pod 1 a třetí pod 2. `length` udává počet zapsaných dnů, zde 3. To už ale není platný index: `pages[3]` by žádalo čtvrtý záznam, který neexistuje. Poslední index je vždy `length - 1`.

## Změna prvku

```java
pages[1] = 8;
```

Jo našla ještě jednu dokončenou stránku z druhého dne. Opravíme proto druhý záznam ze 7 na 8. Pořád máme údaje za stejné tři dny; změna počtu stran nezmění délku pole.

Pokud ještě neznáš hodnoty, použij `new int[3]`. Vytvoří tři místa s počáteční hodnotou `0`. Prázdné pole `new int[0]` nemá žádný platný index.

V další lekci projdeme celé pole cyklem. Zatím stačí bezpečně najít první a poslední prvek neprázdného pole.

Pole přiřadíme do [proměnné](lesson:variables); na rozdíl od jednoho čísla nám zpřístupní více prvků.

## Vytvoření a změna prvků

Celý příklad v `Main.java` ukazuje pole známé délky a jeho výchozí hodnoty:

```java
public class Main {
    public static void main(String[] args) {
        int[] scores = new int[3];
        scores[0] = 10;
        scores[2] = scores[0] + 5;
        System.out.println(scores[0]); // 10
        System.out.println(scores[1]); // 0
        System.out.println(scores[2]); // 15
        System.out.println(scores.length); // 3
    }
}
```

`new int[3]` vytvoří objekt pole se třemi prvky. Každý `int` prvek začíná na nule; místní proměnná bez přiřazení takovou výchozí hodnotu nemá. U pole `boolean[]` je výchozí false a u `String[]` nulové reference. Samotné vytvoření pole textů tedy nevytvoří tři prázdné řetězce.

`length` je údaj pole, ne metoda, proto bez závorek. Index je celé číslo od 0 do `length - 1`. `new int[0]` je platné prázdné pole, ale nemá žádný platný index. `scores[3]` v ukázce vyvolá `ArrayIndexOutOfBoundsException`.

## Délka se nemění, reference ano

Do již vytvořeného pole nelze přidat čtvrté místo. Můžeš vytvořit větší pole a zkopírovat prvky. Přiřazení `scores = new int[5]` pouze přesměruje proměnnou na nový objekt, staré hodnoty nepřenese. Pro časté změny počtu prvků později použijeme `ArrayList`.

## Pole polí

Dvourozměrná data jsou v Javě pole obsahující odkazy na další pole. Do `main` vlož:

```java
int[][] rows = {{1, 2}, {3, 4, 5}};
System.out.println(rows.length);    // 2 řádky
System.out.println(rows[1].length); // 3 prvky druhého řádku
System.out.println(rows[1][2]);     // 5
```

Řádky mohou mít různou délku. Nejprve vybíráš vnější index řádku, potom index v jeho poli. U `new int[2][]` by vnitřní pole ještě nebyla vytvořená a odkazy by obsahovaly null. Ověř zvlášť počet řádků a délku konkrétního řádku; není obecně správně používat pro obě úrovně stejnou hranici.

Zkus pole tří teplot a změň prostřední hodnotu. Předpověz, které výpisy se změní a proč se `length` nezmění nikdy.

> [!OPTIONAL] Pod povrch: index a kontrola hranic
>
> Pole uchovává pevný počet položek a svou délku. Přístup k indexu musí odpovídat pravidlu `0 <= index < length`. Java nedovoluje čtení libovolné paměti za koncem; při neplatném indexu vyvolá výjimku.
>
> ```java
> int[] first = {1, 2};
> int[] second = first;
> second[0] = 9;
> System.out.println(first[0]); // 9
> ```
>
> Přiřazení kopíruje referenci, ne blok prvků. Pole objektů obsahuje reference na objekty, nikoli nutně jejich data v jednom souvislém bloku. Přesné rozložení hlaviček a referencí určuje JVM. Optimalizátor může v některých cyklech prokázat platnost indexu předem a omezit opakované kontroly, ale nesmí povolit neplatný přístup.
