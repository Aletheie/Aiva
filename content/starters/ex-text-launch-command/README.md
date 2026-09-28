# Dustinův terminál trucuje

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Stranger Things**

Dustin připravil pro partu jednoduchý terminál k textové výpravě. Mike má vymyšlenou první místnost, Will nakreslenou mapu a Lucas chce konečně hrát. Ke spuštění prý stačí jediné slovo.

Dustin ho zadá, odsunuje klávesnici s vítězným výrazem — a terminál příkaz odmítne. Při dalším pokusu se ukáže, že drobné mezery mění výsledek. Dustin už navrhuje teorii o rušení z Upside Down. Parta by ocenila, kdyby se nejdřív prověřil samotný text.

</details>
<!-- aiva-story:end -->

Dustin ze Stranger Things testuje terminál do vaší textové hry. Napíše `start`, jenže kolem nechá pár mezer a terminál se tváří, že o takovém příkazu nikdy neslyšel. Pomoz mu: oprav **očištění i porovnání** textu, aby se hra mohla rozběhnout.

Program čte jeden řádek. Na první řádek vypíše očištěný text, na druhý `true` právě tehdy,
když je tento text přesně `start`. Velikost písmen rozlišujeme; `START` není správný příkaz.

Vstup `  start  ` má dát:

```text
start
true
```

Mezery uvnitř textu zachovej. Prázdný vstup má dát prázdný první řádek a pak `false`.
Podmínku `if` ještě nepotřebuješ, vypiš rovnou výsledek porovnání.

## Práce s úlohou

Otevři tuto složku v editoru. Java soubory jsou v `src/main/java`.
Použij JDK 21 nebo novější a před kontrolou soubory ulož.
Nápovědy a vysvětlené řešení jsou v aplikaci.
