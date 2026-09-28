## Dva indexy odpovídají dvěma otázkám

Při rezervaci v kině vybíráš nejprve řadu a pak místo v ní. Stejně se čte `seats[2][1]`: třetí řada, druhé sedadlo, protože oba indexy začínají nulou. Typ `int[][]` znamená pole, jehož prvky jsou další pole celých čísel. Každá řada může mít jiný počet sedadel; Java po nich nepožaduje stejnou délku.

Celý `Main.java` spočítá volná místa po řadách. Nula znamená volné místo, jednička obsazené:

```java
public class Main {
    public static void main(String[] args) {
        int[][] seats = {{0, 1, 0}, {}, {1, 0}};
        for (int row = 0; row < seats.length; row++) {
            int free = 0;
            for (int col = 0; col < seats[row].length; col++) {
                if (seats[row][col] == 0) free++;
            }
            System.out.println("Rada " + (row + 1) + ": " + free);
        }
    }
}
```

Výsledné počty jsou 2, 0 a 1. `seats.length` je počet řad; `seats[row].length` délka právě vybrané řady. Druhá řada existuje, jen neobsahuje žádnou položku. Vnitřní cyklus se v ní neprovede. Nula řad je zase prázdné vnější pole a přeskočí oba cykly.

## Obdélník je jen jedna možnost

`int[][] grid = new int[3][4];` vytvoří tři řady po čtyřech nulách. Můžeš bezpečně přiřadit `grid[2][3] = 7`, nikoli `grid[3][4]`. Oba indexy začínají nulou. `new int[3][]` naopak vytvoří jen vnější pole se třemi chybějícími referencemi. Každou řadu je potřeba nejdřív vytvořit, například `grid[0] = new int[2]`. Jinak přístup k její délce selže.

Když pozice nepotřebuješ, lze psát `for (int[] row : seats)` a uvnitř `for (int seat : row)`. Pro součet je to přehledné. Pro zprávu se souřadnicemi nebo změnu konkrétního místa bývají užitečnější indexy. Při hledání souseda ověř hranici ještě před přečtením sousedního prvku.

## Hledání musí respektovat řádky

Dvě nuly na konci a začátku různých řad nejsou sousední sedadla. Nejprve si proto slovně definuj pořadí hledání: shora dolů, v každé řadě zleva doprava. První nalezený výsledek lze vrátit z pomocné metody pomocí return; ten ukončí metodu i s oběma cykly. `break` by ukončil pouze nejbližší cyklus.

## Kopie vnějšího pole nestačí

Při `int[][] copy = seats.clone()` vznikne nové vnější pole, ale jeho řady odkazují na stejná vnitřní pole. Kdybys v takové „kopii“ zkoušela jiný zasedací pořádek, přepsala bys i původní rezervace: změna `copy[0][0]` se projeví také v `seats[0][0]`. Samostatnou kopii vytvoříš zkopírováním každé řady, například jejím `clone()`. Je to stejný princip sdílených referencí, který dále vysvětlí [předávání hodnotou](lesson:pass-by-value).

Před procvičením si napiš očekávání pro prázdný sál, prázdnou řadu, řadu s jediným místem a dvojici na posledních dvou pozicích. Právě tyto případy odhalí nesprávné meze vnitřního cyklu.
