# Hermiona nechce půjčit jednu knihu dvakrát

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Harry Potter**

V klubové polici zbývá jediný výtisk knihy, o kterou stojí Harry i Ron. Hermiona zapíše první výpůjčku a vzápětí zjistí, že katalog ochotně slíbí stejnou knihu i druhému zájemci.

Rozmnožovací kouzlo by možná změnilo situaci na polici, ale tady jde o obyčejnou evidenci. Hermiona chce, aby si kniha pamatovala, zda je půjčená, a aby další žádost dostala pravdivou odpověď. Jinak bude klub potřebovat více omluvných dopisů než záložek.

</details>
<!-- aiva-story:end -->

Hermionin knižní klub má jeden výtisk oblíbené knihy a dva zájemce. Napiš pravidla výpůjčky tak, aby druhý zájemce nemohl dostat knihu, kterou už má první doma.

U `Book` vyzkoušej `borrow`, `borrow`, `giveBack`, `borrow`. Před spuštěním si napiš, které půjčení má uspět. Doplň v konstruktoru odmítnutí `null` a prázdného názvu: kniha beze jména se v katalogu hledá dost špatně.

Nakresli textový UML diagram s viditelností a návratovými typy. Jiný člověk z něj má poznat, co může s knihou udělat, aniž by četl její vnitřní kód.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Ověřena správná posloupnost dostupnosti.
- Neplatné jméno je odmítnuto v modelu.
- Diagram odpovídá skutečným metodám.
