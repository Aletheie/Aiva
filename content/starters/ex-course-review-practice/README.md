# Stejná výsledkovka, jiná cesta

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

Po turnaji má Ema funkční přehled výrazných výkonů. Lea však při čtení programu ještě lépe rozumí obyčejnému cyklu než streamu, takže si chce stejný postup napsat druhým způsobem a oba porovnat.

Výsledek musí zůstat stejný i u opakovaných jmen a hraničního počtu bodů. Ema nechce, aby s novým zápisem nepozorovaně zmizelo některé kolo. Tentokrát se mění cesta k výsledku, zatímco samotné turnajové záznamy zůstávají rozhodující.

</details>
<!-- aiva-story:end -->

Ema chce po herním večeru seznam výkonů s alespoň 10 body, seřazený podle jména. Varianta se streamem už funguje. Pomoz napsat druhou verzi tak, aby při výměně nezmizely žádné výsledky.

Přepiš `successful` na cyklus s `ArrayList` a následné řazení. Zachovej hranici 10 bodů i duplicity: stejné jméno se může objevit u více kvalifikovaných výkonů. Výsledek má zůstat neměnitelný.

Porovnej obě verze pro běžný vstup, prázdný seznam a dvě stejně pojmenované úspěšné položky. U hranice 9/10 si ověř, že do výsledku patří právě výkon za 10 bodů.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Tři sady vstupů souhlasí s původní variantou.
- Výsledek zachovává duplicity i neměnitelnost.
- Umím vysvětlit každou použitou metodu.
