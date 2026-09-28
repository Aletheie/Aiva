# Robin plánuje nový záhon

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Stardew Valley**

Robin se zastavila u farmy s náčrtem nového záhonu. Za chvíli má zase práci v dílně, takže chce dopředu vědět, kolik zeminy a materiálu na obrubu připravit. Ty zatím přesouváš návrh záhonu, aby zbyla pohodlná cesta od domu.

Každá změna rozměrů znamená nový výpočet dvou různých věcí. Když se spletou, zbude buď hromada zeminy, nebo mezera v posledním rohu. Robin chce zadat rozměry do programu a získat plochu i délku obruby.

</details>
<!-- aiva-story:end -->

Robin ze Stardew Valley ti pomáhá naplánovat obdélníkový záhon pro vlastní farmářskou minihru. Potřebuje plochu pro zeminu a délku obruby, aby materiál došel přesně k poslednímu rohu. V tomto modelu počítáme rozměry v celých metrech, plochu v metrech čtverečních a obvod v metrech.

Doplň `Rectangle.java`. Konstruktor přijme šířku a výšku, uloží je do polí objektu a metody `area()` a `perimeter()` vrátí obsah a obvod jako `int`.

`main` načítá oba rozměry od 1 do 1000 po řádcích, vytvoří obdélník a vypíše nejdřív obsah, potom obvod.

Pro záhon 3 × 4 čekáme řádky `12` a `14`. Čtverec nestačí jako jediný test: ověř i různé strany, aby se odhalilo chybné uložení rozměrů.

## Práce s úlohou

Otevři tuto složku v editoru. Java soubory jsou v `src/main/java`.
Použij JDK 21 nebo novější a před kontrolou soubory ulož.
Nápovědy a vysvětlené řešení jsou v aplikaci.
