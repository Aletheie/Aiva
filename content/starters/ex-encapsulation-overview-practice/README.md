# Enid vrací rezervované lístky

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Wednesday**

Někdo z Nevermore se odhlásí z promítání a Enid mu uvolní místo. Chvíli nato přijde stejná zpráva znovu. Enid ji pro jistotu potvrdí ještě jednou a aplikace nabídne další volnou židli.

Wednesday přepočítá sedadla a zjistí, že program nabízí víc míst, než kolik jich v sále je. Enid potřebuje vrácení lístků, které vydrží i opakovaný pokus nebo špatný údaj.

</details>
<!-- aiva-story:end -->

Enid ruší rezervaci na filmový večer. Místo se má vrátit do nabídky, ale opakované kliknutí nesmí přičarovat další sedadlo. Pomoz opravit vracení míst.

Ve třídě `Seats` si ulož i původní kapacitu a přidej `boolean release()`. Vrátí jedno rezervované místo a oznámí `true`; pokud už jsou všechna místa volná, vrátí `false` a stav nezmění.

Začni sálem pro jediného člověka. Pro `reserve`, `reserve`, `release`, `release` čekej `true`, `false`, `true`, `false` a na konci 1 volné místo. Pak vyzkoušej kapacitu 0. Žádné tajné sedadlo za plátnem.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Stav nikdy neklesne pod nulu ani nepřekročí kapacitu.
- Ověřena kapacita 0 a 1.
- Pole zůstávají private.
