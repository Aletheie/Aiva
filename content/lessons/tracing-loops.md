## Nemusíš držet celý program v hlavě

Když ti nesedí součet na účtence, můžeš si k položkám dopsat průběžný součet a najít první rozdíl. Stejně zkontroluješ cyklus: po každém průchodu si poznamenej hodnoty proměnných. Tomuto sledování se říká **tracing**:

```java
int sum = 0;
for (int i = 1; i <= 3; i++) {
    sum = sum + i;
}
```

| Průchod | i | sum po přičtení |
| --- | --- | --- |
| první | 1 | 1 |
| druhý | 2 | 3 |
| třetí | 3 | 6 |

Po třetím průchodu se `i` zvýší na 4. Podmínka už neplatí a cyklus skončí.

## Otázky, které pomáhají

- Jaké jsou hodnoty před prvním průchodem?
- Co přesně se během průchodu změnilo?
- Kdy podmínka přestane platit?

Hodnoty můžeš dočasně vypisovat přes `println`. Před kontrolou úlohy pomocné výpisy odstraň, aby výstup odpovídal zadání.

Stejnou práci později převezme **debugger** v editoru. Papír ale často stačí.

## Zápis hodnot při rozebírání čísla

Zvol konkrétní malý vstup a zapisuj stav vždy ve stejném místě, například těsně před koncem průchodu. Následující kód patří do `main`:

```java
int value = 507;
int sum = 0;
while (value > 0) {
    int digit = value % 10;
    sum += digit;
    value /= 10;
}
System.out.println(sum); // 12
```

`% 10` oddělí poslední číslici a celočíselné `/ 10` ji odstraní. Zkratka `value /= 10` ukládá podíl zpět.

| Průchod | value před | digit | sum po | value po |
|---|---|---|---|---|
| 1 | 507 | 7 | 7 | 50 |
| 2 | 50 | 0 | 7 | 5 |
| 3 | 5 | 5 | 12 | 0 |

Teprve další kontrola při nule ukončí cyklus. Nula uprostřed čísla není konec vstupu; je to číslice s nulovým příspěvkem.

## Co má platit po každém kroku

Po prvním průchodu máš číslici 7 započtenou v `sum` a v `value` zbývá 50. Po druhém je součet stále 7 a zbývá 5. Na začátku každého dalšího průchodu tedy `sum` obsahuje součet odebraných číslic a `value` část, kterou ještě musíš zpracovat. Takovému pravidlu se říká **invariant cyklu (loop invariant)**. Zároveň vidíš, že se zbývající číslo zmenšuje k nule.

Předpokladem příkladu je nezáporné číslo. Pro nulu správně vyjde součet 0 bez průchodu. Záporná čísla vyžadují doplnění pravidla; neřeš je bez rozmyslu absolutní hodnotou, která má vlastní hranice číselných typů. Ruční tabulka pomáhá najít první odchylku, později stejný postup provedeš s [debuggerem](lesson:debugging-overview).
