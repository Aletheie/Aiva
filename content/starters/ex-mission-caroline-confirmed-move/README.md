# Caroline potvrzuje pokoj až po uložení

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Upíří deníky**

Caroline přesouvá hosty mezi pokoji penzionu v Mystic Falls. Na obrazovce se objeví nové číslo a ona už téměř předá klíč. Bonnie si ale všimne, že uložení změny selhalo a v evidenci zůstal původní pokoj.

Dvě různé informace by při příjezdu dalších hostů rychle způsobily zmatek. Caroline potřebuje potvrdit jen to, co se opravdu podařilo uložit. Nadpřirozených překvapení má město dost; obsazenost pokojů by měla zůstat docela předvídatelná.

</details>
<!-- aiva-story:end -->

Caroline rozděluje hosty do pokojů penzionu. Obrazovka hlásí nový pokoj i tehdy, když uložení selže. Pomoz sladit to, co aplikace ukazuje, s tím, co opravdu uložila.

## Tvůj zásah

Oprav RoomService.move a snapshot. Změnu připrav v kopii mapy a do služby ji zapiš až po úspěšném save. Zachytávej jen očekávanou IOException.

## Připravené okolí

RoomRepository simuluje externí úložiště. Při chybě nic nezapíše; jinak si pořídí vlastní kopii. Main nastavuje chybu pro každou žádost samostatně. Implementaci úložiště ani obrazovky nemusíš znát podrobně. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet žádostí 0–20; u každé jméno na řádku, pokoj na řádku a true/false na dalším (zda příští zápis selže). Trimuj obě hodnoty. Prázdné jméno nebo pokoj jiný než NORTH/SOUTH vrací INVALID bez zápisu. Jinak zkus jednou uložit úplnou novou mapu: při úspěchu potvrď i stav služby a vrať SAVED, při IOException vrať RETRY a zachovej předchozí stav. Nový pokoj stejného jména nahrazuje starý. Metoda snapshot musí vrátit nezávislou kopii mapy; main ji schválně vymaže a znovu načte. Po každé žádosti se vypíší oba stavy a nakonec počet volání save.

Ukázkový vstup:

```text
2
 Elena 
 NORTH 
false
Elena
SOUTH
true
```

Očekávaný výstup:

```text
SAVED
App: {Elena=NORTH}
Disk: {Elena=NORTH}
RETRY
App: {Elena=NORTH}
Disk: {Elena=NORTH}
Zapisy: 2
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
