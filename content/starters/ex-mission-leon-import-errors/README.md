# Leon chce dokončit import i po chybě řádku

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Resident Evil**

Leon přebírá požadavky evakuačních týmů z ručně přepsaných lístků. Ve spěchu se do jednoho počtu dostalo písmeno, jiný tým uvedl hodnotu mimo povolený rozsah. Zbytek seznamu přitom obsahuje normální použitelné žádosti.

První import skončí hned u chyby. Claire se ptá na týmy, které byly zapsané až pod ní. Leon potřebuje dokončit celý přehled a problémové řádky popsat tak, aby šly opravit. Jeden nečitelný údaj nemá připravit ostatní o vybavení.

</details>
<!-- aiva-story:end -->

Leon Kennedy načítá požadavky týmů z ručně psaného seznamu. Jeden překlep nemá zrušit celý import a číslo mimo povolený rozsah potřebuje jiné hlášení než nečíselný text.

## Tvůj zásah

Oprav try/catch/finally v audit. Konkrétnější výjimka musí být zachycena před obecnější a chyba nesmí předčasně vrátit celou metodu.

## Připravené okolí

Parser a načítání všech řádků jsou hotové. Doplňuješ jen hranici, která překládá chyby do užitečných výsledků. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

První řádek je počet položek 0–20, potom libovolné textové řádky. Připravený Parser.read přijímá po trim celé číslo 1–50, pro špatný zápis vyhazuje NumberFormatException a pro rozsah IllegalArgumentException. Vypiš OK: n, FORMAT nebo ROZSAH pro každý řádek. Pokračuj i po chybě. Nakonec Prijato: počet platných a Pokusy: počet všech zpracovaných řádků, počítaný ve finally.

Ukázkový vstup:

```text
4
 2 
text
51
50
```

Očekávaný výstup:

```text
OK: 2
FORMAT
ROZSAH
OK: 50
Prijato: 2
Pokusy: 4
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
