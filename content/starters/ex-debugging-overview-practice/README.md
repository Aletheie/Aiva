# Najdi kolo, ve kterém spadne výsledkovka

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

Herní večer skončil a výsledkovka postupně přičítá všechna kola. Poslední skóre vypadá správně, parta už se chystá vyhlásit pořadí — a program spadne. Ema kontroluje seznam, zda v něm není ještě nějaké zapomenuté finále.

Žádné další kolo se nehrálo. Aplikace se přesto snaží přečíst další položku. Lea otevře debugger, aby společně zachytily přesný okamžik, kdy se běžné počítání promění v hledání údaje za koncem seznamu.

</details>
<!-- aiva-story:end -->

Výsledkovka herního večera správně přičte body ze všech kol a pak spadne, jako by čekala ještě jedno tajné kolo. Pomoz najít okamžik, kdy se index dostane mimo pole.

Nejdřív chybu nasimuluj: ve starteru změň `i < values.length` na `i <= values.length`. Nastav breakpoint do těla cyklu a sleduj `i`, `sum` a délku pole. Zapiš hodnoty těsně před prvním neplatným přístupem.

Až příčinu uvidíš, oprav podmínku a ověř připravené pole i prázdné pole. Výjimku tu nepotřebuješ schovávat do `catch`; potřebuješ zabránit chybnému přístupu.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Poznala jsem první neplatný index.
- Oprava řeší příčinu místo zachycení chyby cyklu.
- Ověřeno neprázdné i prázdné pole.
