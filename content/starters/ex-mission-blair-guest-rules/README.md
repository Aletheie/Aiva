# Blair kontroluje dvě fronty hostů

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Gossip Girl**

Před sálem na Upper East Side vznikly dvě fronty. V jedné stojí hosté s pozvánkou, ve druhé lidé, kteří tvrdí, že je určitě pozval někdo důležitý. Blair řeší seznam a Serena už odhaduje, kolik dalších známých se ještě objeví.

Pomocná aplikace ale různě kombinuje kapacitu a povolení ke vstupu. Stačí projít jinou větví rozhodování a překážka jako by zmizela. Blair potřebuje jeden výsledek pro každého hosta, jinak bude večer řešit fronty místo programu.

</details>
<!-- aiva-story:end -->

Blair Waldorf potřebuje rozlišit hosta, který může dovnitř, od hosta čekajícího na uvolnění místa. Platná pozvánka není důvod obejít kapacitu ani zákaz vstupu.

## Tvůj zásah

Doplň jednu společnou podmínku eligible a odvoď z ní dvě výsledné podmínky. Nekopíruj odlišná pravidla věku do každé fronty.

## Připravené okolí

Vstupy už jsou načtené a výpis očekává dvě logické proměnné. Použij pouze porovnání a logické operátory. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: věk 0–100, pozvánka true/false, blokace true/false, volná místa 0–100. Způsobilý host má alespoň 18 let, pozvánku a žádnou blokaci. inside je true pro způsobilého hosta s volným místem. waiting je true pro způsobilého hosta při nulové kapacitě. Všechny ostatní případy mají obě hodnoty false.

Ukázkový vstup:

```text
18 true false 0
```

Očekávaný výstup:

```text
Dovnitr: false
Ceka: true
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
