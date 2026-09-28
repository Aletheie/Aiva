## Stejná změna, méně psaní

Hráčka získala dalších pět bodů. K dosavadnímu skóre je přičteš takto; předpokládáme už vytvořenou proměnnou `int score`:

```java
score = score + 5;
// Stejnou změnu zapíšeš také:
score += 5;
```

Jsou to dvě alternativy. Pokud spustíš oba řádky za sebou, přičteš celkem deset.

Podobně existuje `-=`, `*=` a `/=`. Například `score -= 2` odečte dvojku. U složeného přiřazení Java převádí výsledek zpět na typ proměnné; pro tyto ukázky proto zůstaň u celých čísel typu `int`.

## Jen o jedničku

```java
int attempts = 0;
attempts++;
System.out.println(attempts); // 1
```

`++` zvýší hodnotu o jedna, `--` ji o jedna sníží. Uvidíš je často v cyklu `for`.

Piš je pro začátek jako samostatný příkaz. `println(attempts++)` navíc rozlišuje starou a novou hodnotu a zbytečně komplikuje čtení.

Zkratka je užitečná, když z ní pořád hned vidíš zamýšlenou změnu.

## Samostatné změny se lépe sledují

Celý příklad do `Main.java`:

```java
public class Main {
    public static void main(String[] args) {
        int score = 10;
        score += 5;
        score *= 2;
        score -= 4;
        score /= 3;
        System.out.println(score); // 8

        int count = 2;
        int oldValue = count++;
        int newValue = ++count;
        System.out.println(oldValue); // 2
        System.out.println(newValue); // 4
        System.out.println(count);    // 4
    }
}
```

Skóre postupně nabývá hodnot 10, 15, 30, 26 a 8; poslední dělení je celočíselné. `count++` poskytne do výrazu starou dvojku a zvýší count na 3. `++count` nejdřív zvýší na 4 a poskytne novou hodnotu. Takový zápis je dovolený, ale běžný kód je často čitelnější se zvýšením na vlastním řádku.

## Složené přiřazení obsahuje převod

`byte value = 1; value += 200;` se přeloží, protože složené přiřazení převede výsledek zpět na byte. Hodnota se ale nevejde a výsledkem bude -55. Naproti tomu `value = value + 200` vyžaduje výslovný cast, protože sčítání probíhá jako int. Zkrácený zápis tedy není pro všechny typy jen mechanické zkrácení textu bez dalších pravidel.

U počítadla pokusů obvykle stačí samostatné `attempts++`. Při ladění pak snadno zjistíš, zda jsi počet přečetla před zvýšením, nebo po něm. Pokud v jednom výrazu hodnotu současně čteš i měníš, rozepsání na dva řádky může hledání chyby usnadnit.
