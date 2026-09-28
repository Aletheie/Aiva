# Sally opravuje účet i jméno rezervace

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Když Harry potkal Sally**

Sally domlouvá další večeři a tentokrát nechce všechny podrobnosti opakovat po telefonu. Do formuláře napíše celé jméno rezervace, počty jídel i částky. Harry přihlíží a tvrdí, že obyčejný seznam na papíře by už dávno stačil.

Potvrzení mu bohužel dává munici: jméno je zkrácené a některé údaje se neposunuly do správných polí. Sally si údaje zkontroluje ještě jednou. Když jsou správně na vstupu, měly by správně dorazit i k účtu.

</details>
<!-- aiva-story:end -->

Sally Albright ověřuje skupinovou objednávku. Pokladna spočítá jídlo, ale ztratí celé jméno a mezery kolem čísel někdy zastaví čtení.

## Tvůj zásah

Oprav načítání tří čísel a jména a doplň cenu. Sleva není za každého člověka.

## Připravené okolí

Proměnná input už existuje. Použij nextLine, trim a Integer.parseInt tak, aby žádný konec řádku nezůstal pro další pole. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Čtyři řádky: počet lidí 1–50, cena menu 0–2000 Kč, sleva na celou objednávku 0 až people*price a celé jméno rezervace. Čísla mohou mít mezery na okrajích. Očisti pouze číselné řádky; jméno zachovej. Vypiš jméno a výslednou cenu po jedné slevě.

Ukázkový vstup:

```text
 3 
 200
50 
Sally Albright
```

Očekávaný výstup:

```text
Rezervace: Sally Albright
Celkem: 550
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
