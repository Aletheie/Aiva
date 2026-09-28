# Dva filtry, jeden seznam hráček

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Ema hledá účastnice v přehledu klubového turnaje. Jednou si pamatuje začátek jména, podruhé jen to, že bylo krátké. Lea jí nabídne dva samostatné programy, ale už při první opravě se ukáže, jak snadno se jejich chování rozejde.

Procházení seznamu je pořád stejné, mění se jen otázka položená každému jménu. Ema chce umět vyměnit tuto otázku a zbytek práce zachovat. Další hledání pak nebude vyžadovat další téměř stejnou kopii.

</details>
<!-- aiva-story:end -->

Ema chystá vyhledávání v seznamu hráček. Jednou chce jména začínající na E, podruhé přesně třípísmenná. Pomoz jí vyměnit pravidlo bez psaní druhého průchodu seznamem.

Použij `select` ze starteru s daty Ada, Eliška, Eva. Zavolej ji jednou pro začátek `E` a podruhé pro délku přesně 3; tělo `select` neměň. Vypiš oba výsledky: `[Eliška, Eva]` a `[Ada, Eva]`.

Před spuštěním si u každého jména řekni, kterým filtrem projde. Stejný seznam tu odpovídá na dvě různé otázky.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Výsledky obou pravidel odpovídají.
- Metoda select zůstává stejná.
- Umím rozlišit definici a vyvolání lambdy.
