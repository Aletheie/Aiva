# Wednesday vrací spis k doplnění

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Wednesday**

Wednesday vede spisy podle toho, co o případu v Nevermore právě ví. Některé teprve otevřela, jiné čekají na ověření a u dalších už má dost podkladů pro uzavření. Enid se nabídne, že jí přehled uspořádá.

Jediný nešťastný příkaz ale pošle spis do stavu, do kterého zatím neměl dojít. Wednesday netouží po barevných štítcích, které lžou. Potřebuje jasné dovolené kroky, včetně možnosti vrátit nehotový případ k doplnění a nesmyslný pokus odmítnout.

</details>
<!-- aiva-story:end -->

Wednesday Addams vede případy od otevření přes kontrolu po uzavření. Příkaz pro nesprávný stav nemá spis potichu posunout jinam.

## Tvůj zásah

Doplň Workflow.next(State state,String command). Rozhoduj podle současného stavu i příkazu, ne jen podle příkazu samotného.

## Připravené okolí

Enum State a zpracování sekvence v main jsou hotové. Metoda vrací nový stav; sama nic nevypisuje ani nikam neukládá. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počáteční stav OPEN, REVIEW, CLOSED nebo CANCELLED, počet příkazů 0–20 a jejich názvy. Přechody: OPEN+SUBMIT→REVIEW; OPEN+CANCEL→CANCELLED; REVIEW+APPROVE→CLOSED; REVIEW+RETURN→OPEN; REVIEW+CANCEL→CANCELLED; CLOSED+REOPEN→OPEN. CANCELLED je konečný. Neznámý či v aktuálním stavu nepovolený příkaz ponechá stav. Po každém příkazu vypiš stav, nakonec Konec: stav.

Ukázkový vstup:

```text
OPEN 4 SUBMIT APPROVE REOPEN CANCEL
```

Očekávaný výstup:

```text
REVIEW
CLOSED
OPEN
CANCELLED
Konec: CANCELLED
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
