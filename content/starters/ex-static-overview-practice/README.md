# Tři lístky, tři majitelky, jedno počítadlo

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Upíří deníky**

Caroline má před akcí v Mystic Falls hotové téměř všechno. Zbývá vytisknout seznam hostů a zkontrolovat počet vydaných vstupenek. Bonnie přihlíží poslední zkoušce aplikace a všimne si, že nově zadané jméno zasáhlo i starší lístky.

Caroline rozhodně neplánovala pozvat třikrát tutéž osobu. Potřebuje společný součet, ale samostatné majitelky jednotlivých kartiček. Květiny už může nechat na místě; teď je třeba uspořádat informace uvnitř programu.

</details>
<!-- aiva-story:end -->

Caroline Forbes z Upířích deníků v tvé aplikaci kontroluje malý seznam hostů. Potřebuje vidět, komu každý lístek patří, i kolik jich bylo vydáno celkem. Pomoz jí tyhle dvě informace nepomíchat.

Ke dvěma připraveným objektům přidej třetí `Ticket` pro Elenu. Vypiš všechny majitelky i společný počet: jména zůstávají různá, vydané lístky jsou 3.

Potom napiš statickou metodu `boolean fits(int count)`, která ověří, zda se skupina vejde do zkušebního prostoru s kapacitou `MAX_SEATS` (30). Přijímá počty od 0 do kapacity včetně. Ověř `-1`, `0`, `30` a `31`: i skupina, která zaplní poslední místo, se stále vejde.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Tři majitelky zůstávají nezávislé.
- Počet vydaných lístků je 3.
- Fits správně ověřuje obě hranice.
