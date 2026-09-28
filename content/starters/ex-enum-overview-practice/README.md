# Lea ruší úkol po zrušeném koncertu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

Lea má v plánovači vyzvednutí lístků na koncert a Ema už vybírá místo na společnou večeři před vystoupením. Pak přijde oznámení, že se koncert ruší. Večeře zůstává, lístky ztrácejí smysl.

Aplikace však nabízí jen čekání a dokončení. Lea úkol nesplnila, ale nechce ho vidět mezi povinnostmi příští měsíc znovu. Potřebuje vyjádřit, že některé věci skončí jinak než úspěchem, a přesto už se k nim není třeba vracet.

</details>
<!-- aiva-story:end -->

Lea má v plánovači úkol „vyzvednout lístky“, ale koncert se zrušil. Úkol není hotový a zároveň už na něm není co dělat. Pomoz plánovači vyjádřit i tenhle stav.

Rozšiř `TaskStatus` o `CANCELLED` s popiskem `Zrušeno`. Doplň výraz `switch`, aby pro něj zbývalo 0 kroků. Vypiš všechny popisky pomocí `values()`.

Nejdřív zkus překlad bez nové větve switche a přečti si hlášení. Potom ji doplň a ověř všechny čtyři stavy. Zrušení se má stát jasnou součástí modelu, ne náhodným textem bokem.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Všechny čtyři popisky jsou dostupné.
- Switch pokrývá nový stav.
- Do souboru bych neukládala ordinal jako stabilní ID.
