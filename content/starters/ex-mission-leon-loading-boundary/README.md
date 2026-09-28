# Leon hledá okamžik přetížení

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Resident Evil**

Leon nakládá bedny do přepravního vozidla ve stanoveném pořadí. Posádka potřebuje vědět, které se ještě vejdou, a u první příliš těžké zastavit. Jill raději kontroluje i pomocný program, než vydá pokyn k odjezdu.

Výpočet jednou započte bednu, která už přesáhne kapacitu, podruhé odmítne přesně zaplněné vozidlo. Leon si připraví malý seznam hmotností a chce sledovat jednotlivé kroky. Chyba se ukáže nejlépe v okamžiku, kdy se rozhoduje o poslední bedně.

</details>
<!-- aiva-story:end -->

Leon Kennedy načítá bedny v daném pořadí. Když se další nevejde, nakládání se zastaví. Program ale někdy započítá i příliš těžkou bednu a jindy odmítne přesné naplnění kapacity.

## Tvůj zásah

Oprav loadPrefix. Před opravou se v debuggeru zastav u kontroly kapacity a zapiš index, součet před přičtením a součet s další bednou. Automatická kontrola ověřuje výsledky; tento rozbor si zkontroluj v editoru.

## Připravené okolí

Main načítá pole a vypisuje neměnný LoadReport. Jeho konstruktor přijímá loaded, weight a stoppedAt. Měníš pouze nakládací algoritmus. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet beden 0–20, kapacita 0–1000 a hmotnosti 0–1000. Nalož nejdelší počáteční úsek, jehož součet nepřekročí kapacitu. Bedny nepřeskakuj. Nulová hmotnost je platná. Vrať počet naložených, součet a index první odmítnuté bedny; pokud se vejdou všechny, index -1.

Ukázkový vstup:

```text
4 5 2 3 1 0
```

Očekávaný výstup:

```text
Nalozeno: 2
Hmotnost: 5
Stop: 2
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
