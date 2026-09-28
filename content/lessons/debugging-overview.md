## Najdi první krok, kde výsledek nesouhlasí

Jo má zapsané 4, 7 a 9 hotových stran. Ručně napočítá 20, ale program jí místo součtu ukáže chybu. **Ladění (debugging)** znamená najít příčinu tohoto rozdílu. Nejdřív napiš vstup, očekávaný výsledek a skutečný výsledek. „Nefunguje součet“ je méně užitečné než „pro `[4, 7, 9]` čekám 20, ale dostanu výjimku“.

Rozliš chybu překladu, chybu za běhu a logickou chybu. Překladač najde neexistující proměnnou, ale neví, jestli sleva měla být deset nebo dvacet procent. Základy [čtení chyb](lesson:reading-errors) teď rozšíříme o debugger IDE.

## Program, který lze krokovat

Celý funkční program v `Main.java`:

```java
public class Main {
    static int total(int[] values) {
        int sum = 0;
        for (int i = 0; i < values.length; i++) {
            sum += values[i];
        }
        return sum;
    }

    public static void main(String[] args) {
        int[] values = {4, 7, 9};
        System.out.println(total(values)); // 20
    }
}
```

Přidej **breakpoint**, bod přerušení, kliknutím do okraje editoru u `sum += values[i]`. Spusť konfiguraci přes Debug, nikoli běžné Run. Program se zastaví před provedením řádku. Pozoruj `i`, `sum` a `values[i]` v panelu proměnných.

| Zastavení před řádkem | i | sum | values[i] | sum po provedení |
|---|---|---|---|---|
| první | 0 | 0 | 4 | 4 |
| druhé | 1 | 4 | 7 | 11 |
| třetí | 2 | 11 | 9 | 20 |

V tabulce je před třetím přičtením ještě `sum == 11`. Teprve po provedení zvýrazněného řádku bude 20. Debugger ti dovoluje tento okamžik zastavit a obě hodnoty porovnat. Pokud se nezastaví, ověř uložený soubor a správnou spouštěcí konfiguraci.

## Tři druhy krokování

**Step over** provede aktuální řádek včetně volané metody a zastaví na dalším řádku v aktuálním kontextu. **Step into** vstoupí do volané metody, takže z `total(values)` uvidíš její první příkaz. **Step out** dokončí aktuální metodu a vrátí se k volajícímu. **Resume** pokračuje k dalšímu breakpointu nebo konci programu. Konkrétní klávesové zkratky se liší podle IDE a systému; hledej tyto názvy akcí.

Panel **Call stack** ukazuje zásobník volání: během `total` uvidíš nahoře `total`, pod ní `main`. Přepnutím rámce sleduješ lokální proměnné příslušného volání, nikoli jiný paralelní výpočet.

## Záměrná chyba o jeden krok

Změň v ukázce `<` na `<=` a spusť znovu. Po třetím průchodu bude `i == 3`, ale platné indexy jsou jen 0, 1 a 2. Vznikne `ArrayIndexOutOfBoundsException`. Výpis chyby, **stack trace**, obsahuje typ, zprávu a místa volání. Najdi první řádek patřící tvému kódu, zde `Main.total`, a teprve potom čti volající `main`.

Oprav příčinu v podmínce. Zachytit výjimku a mlčky vrátit součet by maskovalo chybný průchod. Zkus také prázdné pole: správná varianta vrátí 0 bez vstupu do těla.

## Watches a podmíněný breakpoint

**Watch** je sledovaný výraz, například `i < values.length`. Debugger ho vyhodnocuje při zastaveních. Nevkládej do něj metody měnící stav, třeba `list.remove(0)`: ladění by tím samo měnilo program. Watch `values[i]` bude mimo rozsah při `i == values.length`, což je samo užitečná informace.

**Podmíněný breakpoint** zastaví jen při splnění výrazu, například `i == 2`. Hodí se u dlouhého cyklu. **Exception breakpoint** může zastavit při vyvolání konkrétní výjimky, ještě před případným `catch`.

## Výpisy a minimální reprodukce

Když debugger není po ruce, `System.err.println("i=" + i + ", sum=" + sum)` vypíše stav na standardní chybový výstup. `System.err` je druhý textový kanál vedle `System.out`; pomáhá oddělit diagnostiku od běžného výsledku. Po vyřešení dočasné výpisy odstraň.

Z velkého programu vytvoř **minimální reprodukci**: nejmenší data a několik metod, které chybu stále vyvolají. Neměň deset věcí současně. Uprav jednu příčinu, zopakuj původní vstup a přidej hraniční případ. Později z něj vytvoř [regresní test](lesson:testing-overview), který stejnou chybu zachytí příště.
