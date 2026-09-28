## Dvě cesty

U vstupu na akci se program podle věku rozhodne, zda vypíše ano, nebo ne. **Podmínka (condition)** je otázka s odpovědí `true`, nebo `false`. `if` znamená „pokud“ a `else` „jinak“:

```java
int age = 18;
if (age >= 18) {
    System.out.println("ano");
} else {
    System.out.println("ne");
}
```

Pro 18 se vypíše `ano`. Pro 17 se provede druhá větev.

## Více možností

Pomocí `else if` přidáš další otázku:

```java
if (number < 0) {
    System.out.println("zaporne");
} else if (number == 0) {
    System.out.println("nula");
} else {
    System.out.println("kladne");
}
```

Provede se první vyhovující větev. Zbytek řetězce se přeskočí. Několik samostatných `if` se naopak posuzuje každé zvlášť.

## Ověř hranici

U pravidla „alespoň 18“ zkus hodnoty 17, 18 a 19. To odhalí záměnu `>` a `>=`.

Podmínky můžeš spojovat pomocí `&&` a `||` z [lekce o porovnávání](lesson:logic-and-comparisons). Například dělitelnost čtyřmi vyjádříš `year % 4 == 0`.

Za závorku `if (...)` nepatří středník. Dalším krokem je blok v `{ }`.

## Pořadí větví je součást pravidla

Představ si slevu: od 1000 Kč dvacet procent, od 500 Kč deset procent, jinak nic. Pokud nejdřív zkontroluješ `price >= 500`, zachytíš i cenu 1200 a k vyšší slevě se řetězec nedostane. Začni tedy konkrétnější vyšší hranicí:

```java
int price = 1200;
int discountPercent;
if (price >= 1000) {
    discountPercent = 20;
} else if (price >= 500) {
    discountPercent = 10;
} else {
    discountPercent = 0;
}
System.out.println(discountPercent); // 20
```

Úryvek patří do `main`. Proměnná je přiřazena v každé větvi, takže je za podmínkou bezpečně dostupná. Deklarace uvnitř jediné větve by platila jen v jejím bloku. Pro 499, 500, 999 a 1000 očekávej postupně 0, 10, 10 a 20.

## Vnoření a nezávislé otázky

Dva samostatné `if` mohou oba proběhnout, například upozornění na vysokou cenu a současně na nedostatek peněz. `if/else` vybírá jednu cestu. Vnořený `if` se vyhodnotí jen tehdy, když se do něj přes vnější blok dostaneme. Pokud kontroluješ dvě podmínky pro stejnou akci, může být přehlednější je spojit přes `&&`.

Bez složených závorek patří k `if` jen jeden následující příkaz. Odsazení samo pravidlo nezmění. Piš závorky i u jednoho řádku; pozdější přidání výpisu pak omylem nezmění význam.

## Přestupný rok jako přesné pravidlo

Rok je přestupný, pokud je dělitelný 400, nebo je dělitelný 4 a současně není dělitelný 100. Zápis je `year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)`. Pro 2000 a 2024 je true, pro 1900 a 2023 false. Kalendář oslav tak může nabídnout 29. únor v roce 2000, ale v roce 1900 ho musí vynechat. Tato dvě data pomáhají ověřit pravidlo pro celé století.
