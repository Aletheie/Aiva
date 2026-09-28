# Scully odmítá podezřelé štítky

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Akta X**

Scully třídí nové štítky k případům. Mulder přinesl několik dalších podivností a většinu z nich už označil velmi přesvědčivými pracovními názvy. Pro archiv je však potřeba jednotný kód, podle kterého se dá záznam najít.

Kontrola teď přijme i řetězec, v němž správný kód tvoří jen malý kousek. Scully chce ověřit celý štítek, než ho připne ke spisu. Záhadný může zůstat obsah případu; jeho označení by mělo splnit obyčejná přesná pravidla.

</details>
<!-- aiva-story:end -->

Scully z Akt X přebírá digitalizované spisy. Některé štítky obsahují správný kód schovaný uprostřed poznámky, jiné ztratily nuly. Pro archiv potřebuje přesný celý štítek; mimozemský původ není přijatelná výjimka z formátu.

Oprav vzor CODE a způsob ověření vstupu. Platný kód má přesně dvě velká písmena ASCII A–Z, pomlčku a tři číslice ASCII 0–9. Žádné mezery před ani za kódem. Při úspěchu vypiš oddělení a trojčíslí; nuly zachovej jako text. Jinak pouze `Neplatny kod`.

Vstup `XF-007` má výstup:

```text
Oddeleni: XF
Spis: 007
```

`poznamka XF-007`, `XF-007x`, `xf-007`, `XF-7` i prázdný řádek jsou neplatné. Skupiny čti až po úspěšném matches(). Jde o formát vymyšlený pro úlohu, nikoli skutečné pravidlo seriálu. Viz [regulární výrazy](lesson:regular-expressions).

## Spuštění

JDK 21 nebo novější. Otevři složku v editoru, doplň místa TODO a ulož soubory.
V AIVA spusť kontrolu uloženého kódu. Ručně můžeš ze složky cvičení spustit:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java
java -cp out Main
```
