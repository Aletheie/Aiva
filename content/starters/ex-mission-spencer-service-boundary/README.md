# Spencer sjednocuje kontrolu záznamů

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pretty Little Liars**

Spencer přidala k archivu stop novou obrazovku. Hanna přes ni vloží poznámku bez textu a další import potichu přepíše záznam se stejným označením. Při pátrání po „A“ je taková nenápadná změna podkladů zvlášť nepříjemná.

Obrazovky i úložiště už fungují, chybí však společná kontrola mezi nimi. Spencer potřebuje jediné místo, které odmítne neplatný zápis bez ohledu na jeho původ. Jinak by každé nové ovládání mohlo vytvořit další cestu, jak přijít o důkaz.

</details>
<!-- aiva-story:end -->

Spencer má obrazovku i úložiště hotové. Chyba je mezi nimi: prázdné poznámky procházejí a opakované ID tiše přepisuje původní důkaz. Pomoz opravit službu, aby stejné pravidlo platilo pro každou obrazovku.

## Tvůj zásah

Oprav EvidenceService.register. Služba zpracovává pravidla a vrací Result; nevypisuje na konzoli. Nevytvářej další repository, použij předané.

## Připravené okolí

Main představuje obrazovku. EvidenceRepository zastupuje databázi a počítá volání; all slouží pouze připravenému výpisu. Tyto části můžeš používat podle jejich metod, aniž bys měnila jejich implementaci. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet žádostí 0–20, u každé ID na řádku a poznámka na dalším. ID i poznámku ořízni trimem; ID navíc převeď na velká písmena přes Locale.ROOT. Prázdná hodnota znamená INVALID bez přístupu do repository. U platných dat proveď jeden contains; existující ID znamená DUPLICATE bez zápisu. Jinak ulož právě jednou a vrať ADDED. Main vypíše výsledky, uložené záznamy v pořadí přijetí a počty čtení/zápisů.

Ukázkový vstup:

```text
3
 a1 
 Library 
A1
Other
b2
 Train 
```

Očekávaný výstup:

```text
ADDED
DUPLICATE
ADDED
A1:Library
B2:Train
Pristupy: 3/2
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
