# Sherlock počítá i s chybějící stopou

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Sherlock Holmes · současná variace**

Watson chce vyrazit na místo nálezu, jenže v digitálním archivu z Baker Street najde u kódu stopy prázdné pole. Holmes mezitím rozvíjí teorii, která by se dala ověřit jedinou návštěvou. Chybí právě ta nejpraktičtější informace: kam jít.

Program zatím ochotně vytiskne technickou prázdnou hodnotu, jako by šlo o adresu. Watson potřebuje dostat použitelnou stopu, nebo jasnou zprávu, že místo zatím neznají.

</details>
<!-- aiva-story:end -->

Sherlockův archiv někdy obsahuje jen kód bez místa nálezu. Watson nechce vytisknout `null` jako adresu a vyrazit na neexistující ulici. Vrať použitelnou stopu, nebo výslovně řekni, že zatím chybí.

Doplň `clue(Map<String,String> archive, String code)` tak, aby vždy vracela nenulový Optional. Chybějící klíč, prázdná hodnota nebo hodnota ze samých mezer znamená Optional.empty(). Ostatní text ořízni přes strip; vnitřní mezery zachovej. Doslovné `null` je normální text.

Starter čte počet záznamů 0–20, řádky `kod|misto` a nakonec hledaný kód. Kódy jsou neprázdné a jedinečné, hodnoty neobsahují další |. Pro `1`, `A7|  Baker Street  ` a `A7` na třech řádcích má vyjít `Stopa: Baker Street`. Neexistující kód vypíše `Stopa: zatim bez stopy`.

Nepoužívej get() bez kontroly a nevracej samotné null. Formátování i náhradní text řeší připravený Main. Viz [Optional](lesson:optional-values).

## Spuštění

JDK 21 nebo novější. Otevři složku v editoru, doplň místa TODO a ulož soubory.
V AIVA spusť kontrolu uloženého kódu. Ručně můžeš ze složky cvičení spustit:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java
java -cp out Main
```
