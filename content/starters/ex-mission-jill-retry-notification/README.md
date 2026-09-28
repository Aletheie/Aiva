# Jill opakuje jen neodeslané hlášení

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Resident Evil**

Jill odesílá hlášení týmu na druhé straně uzavřeného průchodu. Spojení vypadne právě během přenosu. Na obrazovce už ovšem svítí, že zpráva odešla, a další pokus program odmítá jako zbytečný.

Jill ví, že stisknout vysílačku a být skutečně slyšena jsou dvě různé věci. Potřebuje záznam, který dovolí zopakovat neúspěšné doručení, ale nebude znovu posílat potvrzenou zprávu. Stav v přehledu musí odpovídat tomu, co se opravdu podařilo.

</details>
<!-- aiva-story:end -->

Jill Valentine potřebuje rozlišit už doručené hlášení od pokusu, který selhal. Příliš brzké označení jako odeslané znemožňuje bezpečný další pokus.

## Tvůj zásah

Oprav Delivery.deliver. Pořadí kontroly, pokusu a zapamatování je součástí správnosti.

## Připravené okolí

Notifier je připravené rozhraní, TestNotifier jen místní simulace bez sítě. SentIds nabízí has, remember a size; vnitřní Set nemusíš měnit. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet pokusů 0–20 a dvojice ID/true-false, zda v daném pokusu funguje zkušební odesílač. Pokud ID už bylo úspěšně odesláno, vrať UZ ODESLANO a odesílač nevolej. Jinak ho zavolej: při false vrať CHYBA a ID neukládej; při true ulož ID a vrať ODESLANO. Na konci main vypíše počet skutečných volání a zapamatovaných ID.

Ukázkový vstup:

```text
3 A false A true A true
```

Očekávaný výstup:

```text
CHYBA
ODESLANO
UZ ODESLANO
Pokusy: 2
Ulozeno: 1
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
