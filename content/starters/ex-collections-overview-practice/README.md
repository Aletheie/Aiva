# Kdo vyhrál kolik kol?

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Na kolejním herním večeru se rychle střídají partie a Ema stíhá zapisovat jen vítězná jména. Ada vyhraje, potom Eva, potom zase Ada. Lea mezitím přinese občerstvení a položí jednoduchou otázku: kdo vlastně vede?

Seznam odpověď obsahuje, ale zatím ji nikdo nesestavil. Ema chce počítat vítězství pod jednotlivými jmény, i když se některá opakují mnohokrát. Hodila by se výsledkovka, která vydrží další kolo bez nového ručního počítání.

</details>
<!-- aiva-story:end -->

Na kolejním herním večeru si Ema zapisovala jen jména vítězek jednotlivých kol: Ada, Eva, Ada. Pomoz jí sestavit výsledkovku, než někdo začne body počítat podruhé.

Z `List.of("Ada", "Eva", "Ada")` vytvoř `Map<String, Integer>` s počty výher. Vypiš počty pro Adu, Evu a Ivu v tomto pořadí: `2`, `1`, `0`. Iva zatím nevyhrála žádné kolo, ale dotaz na ni nesmí program shodit.

Ověř také prázdný seznam. Pořadí výpisu neurčuj podle náhodně vypadajícího pořadí celé `HashMap`; konkrétní hráčky vyhledej podle jména.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Výsledky jsou 2, 1 a 0.
- Funguje prázdný seznam.
- Nevyužívám pořadí HashMap jako záruku.
