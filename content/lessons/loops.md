## Jeden krok vícekrát

Na pět krabic potřebuješ vytisknout čísla 1 až 5. Místo pěti skoro stejných výpisů zadáš, kde číslování začne a kdy skončí. **Cyklus (loop)** pak stejný příkaz opakuje s postupně se měnícím číslem:

```java
for (int number = 1; number <= 5; number++) {
    System.out.println(number);
}
```

Vypíše čísla 1 až 5, každé na nový řádek.

## Tři části závorky

1. `int number = 1`: začni jedničkou. Provede se jen na začátku.
2. `number <= 5`: před každým průchodem ověř, zda pokračovat.
3. `number++`: po průchodu přičti jedničku.

Jakmile podmínka neplatí, program pokračuje za cyklem. Proměnná `number` vytvořená v záhlaví je dostupná jen uvnitř tohoto cyklu.

## Průběžný součet

```java
int sum = 0;
for (int number = 1; number <= 3; number++) {
    sum = sum + number;
}
System.out.println(sum); // 6
```

Součet založ **před cyklem**. Funguje jako průběžná částka na účtu: k dosavadní hodnotě přidáváš další položku. Kdybys ho uvnitř cyklu pokaždé znovu nastavila na nulu, zapomněl by všechny předchozí položky.

Ověř také nula průchodů a poslední číslo. Rozdíl mezi `<` a `<=` často rozhoduje o tom, jestli něco chybí.

O opakování rozhoduje stejný druh [podmínky](lesson:conditions), který už znáš z `if`.

## Zapiš si skutečné pořadí

U `for (int i = 0; i < 3; i++)` proběhne inicializace, kontrola, tělo, zvýšení, kontrola, tělo a tak dále. Po posledním zvýšení na 3 se podmínka vyhodnotí na false a tělo už neběží. Hodnoty použité v těle jsou tedy 0, 1 a 2, nikoli 3.

```java
int sum = 0;
for (int i = 0; i < 3; i++) {
    sum += i;
    System.out.println(i + ": " + sum);
}
```

Očekávej řádky `0: 0`, `1: 1`, `2: 3`. `sum += i` zde znamená `sum = sum + i`. Proměnná mimo cyklus uchovává průběžný stav, proměnná vytvořená uvnitř těla by se zakládala pro každý průchod znovu.

## Vnořené cykly

Představ si kontrolu sedadel v kině: projdeš všechna sedadla první řady, potom všechna sedadla druhé. Vnější cyklus vybírá řadu a vnitřní jednotlivá místa v ní. Následující kód v `main` vytvoří dva řádky po třech hvězdičkách:

```java
for (int row = 0; row < 2; row++) {
    for (int column = 0; column < 3; column++) {
        System.out.print("*");
    }
    System.out.println();
}
```

Vnitřní inicializace se opakuje při každém novém řádku. Bezparametrické `println()` pouze ukončí řádek. Celkem se hvězdička vypíše 2 × 3krát; pokud obě hranice rostou s počtem dat, může množství práce růst jako součin.

## Kdy zvolit for

Pro přesně deset pokusů nebo indexování pole je `for` přehledný. Pro čtení do příkazu konec je přirozený [while](lesson:while-loops). Cyklus s rozšířeným `for (Typ prvek : hodnoty)` později projde všechny prvky [pole](lesson:array-traversal) nebo kolekce bez ručního indexu.

Změň hranici 3 na 0 a předpověz nulový počet průchodů. Potom zkus sestup `for (int i = 3; i > 0; i--)`: tělo uvidí 3, 2 a 1. Zvýšení místo snížení by podmínku neposouvalo ke konci.
