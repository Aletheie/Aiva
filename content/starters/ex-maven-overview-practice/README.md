# Sestav první balíček pro Leu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Lea dostane zprávu, že je nová klubová aplikace hotová. V příloze najde obrázek konzole a několik souborů z různých složek. Pozná, jak výsledek vypadal u autorky, ale k vlastnímu spuštění má pořád daleko.

Parta se proto domluví na skutečném předání projektu. Má obsahovat to, co umožní znovu přeložit kód, spustit kontroly a vytvořit balíček. Lea chce příště řešit, co aplikace umí, nikoli kam se ztratil poslední důležitý soubor.

</details>
<!-- aiva-story:end -->

Lea chce vyzkoušet tvůj program. Připrav jí projekt včetně souborů potřebných k sestavení.

Otevři starter ve složce s `pom.xml`. Postupně spusť `mvn compile`, `java -cp target/classes Main` a `mvn package`. Najdi výsledný JAR.

Do krátké poznámky pro Leu napiš, jaké JDK potřebuje, odkud příkazy spustit a kde vznikne výsledek. Na konkrétním POM jí vysvětli `release`, `dependency` a `plugin`. Ověř také, zda tento build opravdu spustil nějaké testy; zelený výsledek sám o sobě jejich existenci nedokazuje.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Compile i package uspěly.
- Java vypíše očekávaný text.
- Umím najít POM, zdroje a generovaný výstup.
