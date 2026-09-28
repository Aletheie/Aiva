# Ada & Eva chtějí společnou jmenovku

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Ada a Eva si pro herní duo vybraly jméno, které se vejde na společnou jmenovku. Ema ho uloží do klubové aplikace a po opětovném načtení se místo pěkného názvu objeví chyba dokumentu.

Potíž způsobuje znak mezi oběma jmény. V běžném textu je nenápadný, v XML ale plní i jinou úlohu. Lea chce zachovat přesně zvolený název a zároveň vytvořit dokument, který se dá znovu přečíst. Ada s Evou si svůj název chtějí ponechat.

</details>
<!-- aiva-story:end -->

Duo Ada & Eva si do klubové aplikace zadalo společné jméno. Jenže znak `&` má v XML vlastní význam. Pomoz jméno uložit a načíst celé, aniž by se rozbil dokument.

Ve vstupním XML změň jméno na `Ada &amp; Eva`. Vypiš načtený text a zkontroluj výstupní XML s atributem `active`: na obrazovce má být obyčejné `&`, v souboru správně zapsaná entita.

Pak vynech úvodní zápis a zkus dokument bez elementu `name`. Program má oznámit konkrétní validační chybu, ne si chybějící jméno domyslet.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Text se správně přečte i znovu zapíše.
- Chybějící element není zaměněn za prázdné jméno.
- Parser nepokračuje bez bezpečnostních nastavení.
