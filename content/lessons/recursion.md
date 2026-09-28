## Metoda může zavolat sama sebe

Součet tří čísel můžeš rozdělit na první číslo a součet zbývajících dvou. Ten zase na první číslo a součet zbytku. Metoda při tom řeší stejný úkol pro stále kratší část pole a volá sama sebe. To je **rekurze (recursion)**. Jakmile nezbývá žádné číslo, vrátí nulu a další volání už nepotřebuje.

Celý `Main.java` spočítá součet od zadané pozice do konce pole:

```java
public class Main {
    static int sumFrom(int[] values, int index) {
        if (index == values.length) return 0;
        return values[index] + sumFrom(values, index + 1);
    }

    public static void main(String[] args) {
        int[] points = {4, 2, 7};
        System.out.println(sumFrom(points, 0)); // 13
        System.out.println(sumFrom(new int[0], 0)); // 0
    }
}
```

Metodě předáváme malé pole, které nesmí být `null`, a index od nuly do délky pole včetně. Prázdné pole je povolené. Při indexu rovném délce už nejsou žádné hodnoty, takže vracíme nulu. Pole v metodě neměníme. Pro studijní příklad předpokládáme, že se součet vejde do int; rekurze sama přetečení čísel neřeší.

## Které volání na co čeká

Každé volání má rozpracovaný vlastní součet:

| Index | Výpočet | Vrácená hodnota |
| --- | --- | --- |
| 0 | 4 + výsledek od indexu 1 | 4 + 9 = 13 |
| 1 | 2 + výsledek od indexu 2 | 2 + 7 = 9 |
| 2 | 7 + výsledek od indexu 3 | 7 + 0 = 7 |
| 3 | Konec pole, vrátí rovnou 0 | 0 |

Volání vznikají shora dolů, ale výsledky se vracejí od posledního řádku nahoru.

Právě tento návrat je rozdíl proti představě, že rekurzivní volání pouze skočí na začátek metody. Původní volání nezmizelo. Jeho parametry a rozpracovaný výraz čekají v zásobníku. V debuggeru použij Step into a prohlédni si více rámců stejné metody s různými hodnotami indexu.

## Tři otázky před spuštěním

Kdy končím? Co je po každém volání menší? Je konec dosažitelný ze všech povolených vstupů? Pokud v příkladu předáš znovu stejný index, metoda neskončí a dojde k StackOverflowError. Pokud nejdřív přečteš values[index] a až potom ověříš konec, rozbiješ prázdné pole i závěrečné volání.

Pro lineární součet je cyklus jednodušší a spotřebuje stálou pomocnou paměť. Rekurze ukládá rámec pro každý prvek, tedy paměť úměrnou délce. Java nezaručuje odstranění koncových rekurzivních volání. Ani správný základní případ proto nedělá velmi hlubokou rekurzi bezpečnou.

## Kde rekurze pomáhá

Přirozená je při procházení vnořených struktur: složka obsahuje další složky, výraz další výrazy. Při počítání souborů ve složce tak použiješ stejný postup pro každou její podsložku. I tak musíš hlídat hloubku a případné cykly odkazů. Pro obyčejné počítadlo není důvod nahrazovat přehledný while rekurzí.

V úloze se zrcadlovou zprávou procvičíš základní případ a postupné vracení výsledku na krátkém textu. Vstupní limit je součástí zadání, protože řetězení textů vytváří mezivýsledky a dlouhý text by nebyl dobrým použitím tohoto algoritmu.
