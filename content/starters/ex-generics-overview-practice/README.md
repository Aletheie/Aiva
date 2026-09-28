# Lobby čeká na „připravena“

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

V herní lobby svítí jména hráček a vedle každého malý ukazatel připravenosti. Ema čeká na start, Lea zkouší poslední připojení a někdo místo přepnutí stavu pošle text „ano“.

Lidem zpráva dává smysl, program ale potřebuje jednoznačnou hodnotu, podle níž spustí hru. Lea chce chybný údaj zachytit už při sestavování. Jinak se parta může dohadovat, proč jsou všechny připravené, ale lobby s tím zjevně nesouhlasí.

</details>
<!-- aiva-story:end -->

Lea staví herní lobby. Stav připravenosti má být jednoznačné ano/ne, jenže někdo do něj chce poslat text `ano`. Pomoz zachytit chybný typ dřív, než se hra spustí.

V `main` vytvoř `Box<Boolean>` s `false`. Po potvrzení připravenosti nastav `true`, přečti hodnotu do `boolean` a vypiš ji. Potom zkus `ready.set("ano")` a ověř, že překladač tento zápis odmítne.

Chybný řádek zase odstraň a program spusť. Vysvětli, proč stejná krabička jednou přijímá `Boolean` a jindy třeba `Integer`, ale v jednom konkrétním použití mezi typy nepřeskakuje.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Výsledek je true.
- Chybný typ je odmítnut před spuštěním.
- Vysvětlím boxing i riziko rozbalení null.
