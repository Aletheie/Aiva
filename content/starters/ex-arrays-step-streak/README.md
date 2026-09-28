# Ema a Lea hledají nejdelší sérii

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

Ema s Leou vytvořily vlastní mapu městských výprav: knihkupectví, kino, zapomenutý park a kavárna, kde se dá hodinu debatovat o adaptacích. Každý den chtějí dojít někam jinam a splnit společný krokový cíl.

Po týdnu ukazuje aplikace pěkný součet, ale Ema tvrdí, že jejich nejlepší souvislá série byla delší. Lea vytáhne denní záznamy a najde jeden deštivý den, který rekord přerušil. Teď potřebují odlišit celkovou aktivitu od výdrže bez přestávky.

</details>
<!-- aiva-story:end -->

Ema s Leou si daly výzvu: každý den projít jinou část města. Jejich přehled sleduje cíl 6000 kroků denně, ale rekordní sérii zatím počítají ručně. Zjisti, kolik dnů za sebou svůj cíl splnily.

Doplň `static void printSummary(int[] steps)`: vypíše celkový počet kroků, počet dní s alespoň 6000 kroky a nejdelší nepřerušenou sérii takových dní. Pole neměň.

Připravený `main` načte počet dní (0–31) a potom kroky jednotlivých dní (0–50000), každý údaj na vlastním řádku.
Pro pět dní s hodnotami 6000, 8000, 2000, 7000, 6000 má být výstup:

```text
Celkem: 29000
Splneno: 4
Serie: 2
```

Nejprve rozchoď součet, potom počet splněných dní a nakonec sérii. Den pod limitem ji přeruší.
Prázdné pole dává ve všech třech řádcích nulu. Hranice 6000 se počítá jako splnění.

## Práce s úlohou

Otevři tuto složku v editoru. Java soubory jsou v `src/main/java`.
Použij JDK 21 nebo novější a před kontrolou soubory ulož.
Nápovědy a vysvětlené řešení jsou v aplikaci.
