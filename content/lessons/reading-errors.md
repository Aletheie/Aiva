## Začni první chybou

Jedna chybějící závorka může vyvolat několik hlášení. Oprav první problém a zkus překlad znovu.

Hlášení může obsahovat třeba `Main.java:4`: podívej se na řádek 4, ale i na řádek před ním. Tam může chybět středník.

## Tři časté zprávy

- `';' expected`: překladač očekává středník.
- `cannot find symbol`: nezná dané jméno. Zkontroluj překlep a velká písmena.
- `unclosed string literal`: text nemá zavírací uvozovku.

Přesné znění se může lišit podle nástroje. Hlavní je soubor, řádek a popis.

## Jak požádat o pomoc

Uveď, co chceš udělat, malou ukázku kódu a přesnou chybu. Místo „nejde to“ například: „Chci vypsat pozdrav; javac hlásí chybějící středník.“

Zkus jednu opravu, ulož soubor a znovu spusť kontrolu. Chybové hlášení je běžná součást práce.

## Nejde vždy o stejný druh chyby

Překladač může hlásit `incompatible types`: například číslo očekávané typem `int` dostalo text. Hlášení „public class Main should be declared in a file named Main.java“ ukazuje nesoulad jména veřejné třídy a souboru. Obě chyby brání novému překladu; samotné opakované kliknutí na Run je neodstraní.

Chyba za běhu naproti tomu může vypadat takto:

```text
Exception in thread "main" java.lang.ArithmeticException: / by zero
    at Main.main(Main.java:5)
```

`ArithmeticException` pojmenovává chybu ve výpočtu, `/ by zero` říká, že program dělil nulou, a `Main.java:5` ukazuje na řádek 5. U rozdělení účtu se tedy podívej, kolik lidí program započítal. Další řádky mohou ukazovat, odkud se chybný výpočet zavolal. Nemusíš jim rozumět všem, abys našla první příčinu.

## Malý experiment

Ve funkčním programu změň `println` na `printl`. Překladač nezná takovou metodu a ohlásí chybějící symbol. Pak název vrať a změň číslo v platném výpočtu tak, aby výsledek porušoval zadání. Program se může spustit bez chyby, a přesto být nesprávný. K odhalení druhého problému potřebuješ očekávaný výsledek.

Zaznamenej vždy nejmenší vstup, který problém vyvolá, a jednu provedenou opravu. Pokud nový výpis ukazuje jiné místo, znovu ho přečti; nemusí jít o pokračování téže chyby. Další nástroje uvidíš v [ladění s breakpointy](lesson:debugging-overview).
