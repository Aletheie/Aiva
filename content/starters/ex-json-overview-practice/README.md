# Zachraň Adin herní profil

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

Ada si chce před dalším herním večerem načíst svůj profil. V souboru někdo zkoušel upravovat body a ponechal tam zápornou hodnotu. Ema spustí import, který chybu objeví, ale vzápětí ohrozí i původní soubor.

Ada by ráda zachovala alespoň data, ze kterých se dá problém dohledat a napravit. Program má neplatný profil srozumitelně odmítnout. Chyba v jednom čísle není důvod, aby spolu s ní zmizelo celé dosavadní hraní.

</details>
<!-- aiva-story:end -->

Ada si načítá uložený herní profil. Soubor vypadá jako správný JSON, ale někdo do něj zapsal záporné body. Pomoz chybu oznámit tak, aby při tom nezmizel celý soubor.

Spusť ukázku s Gson. Pro další pokus vynech úvodní zápis, změň body v `profile.json` na `-1` a načti ho znovu. Ověř chybovou zprávu i to, že soubor zůstal beze změny.

Nakonec oprav body a vyzkoušej přezdívku s uvozovkou, například `Ada "A"`. Po uložení a načtení má dostat zpět tentýž text, ne rozbitý JSON.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu. Před spuštěním nech IDE načíst Maven závislosti; obyčejný javac bez classpath knihovnu nenajde.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Ověřen platný i neplatný profil.
- Poškozený soubor se při odmítnutí nezmění.
- Vysvětlím toJson, fromJson a Profile.class.
