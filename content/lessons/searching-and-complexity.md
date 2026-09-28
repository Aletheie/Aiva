## Kolik položek musíš prohlédnout

V deseti knižních kartičkách najdeš hledaný titul rychle i postupným čtením. U deseti tisíc už oceníš abecední pořadí, díky kterému můžeš celé části přeskočit. **Časová složitost (time complexity)** popisuje, jak s velikostí vstupu roste množství práce. Zápis **Big O** vyjadřuje horní mez tohoto růstu pro velké vstupy; neudává milisekundy ani rychlost konkrétního počítače.

Lineární hledání čte postupně prvky až do shody. V nejhorším případě navštíví všech n položek, tedy O(n). Přímý přístup k položce pole přes známý index má O(1). Dva vnořené průchody přes všech n položek mohou mít O(n²); samotná přítomnost dvou cyklů však nestačí, musíš zjistit jejich skutečné meze.

## Půlení funguje díky seřazení

Celý soubor `Main.java` obsahuje binární hledání libovolné shody:

```java
public class Main {
    static int indexOf(int[] values, int wanted) {
        int low = 0;
        int high = values.length - 1;
        while (low <= high) {
            int middle = low + (high - low) / 2;
            if (values[middle] == wanted) return middle;
            if (values[middle] < wanted) low = middle + 1;
            else high = middle - 1;
        }
        return -1;
    }

    public static void main(String[] args) {
        System.out.println(indexOf(new int[]{2, 5, 9, 14}, 9)); // 2
    }
}
```

Předpokladem je vzestupně seřazené pole. Pokud prostřední hodnota nestačí, celý levý úsek včetně středu je také příliš malý. Pokud je příliš velká, vyřadíme pravý úsek. V poli `{2, 5, 9, 14}` při hledání devítky nejprve porovnáš prostřední pětku. Devítka je větší, takže zahodíš levou část i pětku a pokračuješ v `{9, 14}`. Každý krok tak zmenší interval přibližně na polovinu. Počet porovnání roste jako O(log n), pomocná paměť této iterativní varianty je O(1).

## Která část pole ještě zbývá

Po celou dobu platí: hledaná hodnota, pokud ještě může existovat, leží v intervalu low až high včetně. Prázdný interval znamená low > high. Proto i prázdné pole funguje: high začíná na -1 a cyklus se neprovede. Posun hranice musí přeskočit právě vyzkoušený střed, jinak se dvouprvkový interval může zaseknout.

Při duplicitách tato ukázka nemusí vrátit první shodu. Pokud zadání požaduje nejnižší index, ulož nalezenou pozici a pokračuj vlevo. V zadání vždy rozliš, zda hledáš existenci, libovolnou shodu, nebo první výskyt.

## Připravit data také něco stojí

Když kvůli jedinému dotazu nejprve seřadíš celé pole, přidáš cenu třídění a případně změníš pořadí vstupu. Pro jeden dotaz může být lepší obyčejný průchod. Pro mnoho dotazů nad stejnými daty se příprava vyplatí. Mapa umožňuje průměrně rychlé hledání podle klíče, ale potřebuje další paměť a řeší jiné otázky než seřazený interval.

Měř až hotovou správnou variantu na reprezentativních datech; jeden běh v debuggeru není spolehlivý benchmark JVM. Nejdřív ověř nulu prvků, hranice, nenalezení a duplicity. Teprve u správného výsledku má smysl porovnávat čas s obyčejným průchodem.
