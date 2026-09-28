# Dvě kopie lístku, jeden vstup

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

U vstupu na con si Ema všimne, že její mobil i notebook ukazují stejnou vstupenku. Pořadatelka otevře oba záznamy a zkušební aplikace se začne chovat, jako by přišly dvě různé návštěvnice.

Ema by druhý vstup sice mohla věnovat Lee, ale seznam má odpovídat prodaným lístkům. Potřebuje rozpoznat stejný kód i tehdy, když vznikly dvě samostatné kopie objektu. Důležité je, co vstupenka představuje, ne na kterém zařízení byla načtena.

</details>
<!-- aiva-story:end -->

Ema si uložila vstupenku do mobilu i do notebooku. Jsou to dva objekty, ale představují stejný kód. Pomoz čtečce rozlišit stejný obsah od stejného objektu.

V `main` vytvoř kódy `A7`, `A7` a `B8`. Předpověz a pak vypiš šest výsledků: totožnost prvních dvou, jejich rovnost, shodu hashů, rovnost s `B8`, s `null` a s obyčejným textem `A7`.

U každého výsledku vysvětli proč. Stejné znaky samy o sobě neznamenají, že `TicketCode` a `String` jsou stejný druh hodnoty.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Ověřeno všech šest porovnání.
- Stejný obsah má stejný hash.
- Rozlišuji totožnost, rovnost a kolizi.
