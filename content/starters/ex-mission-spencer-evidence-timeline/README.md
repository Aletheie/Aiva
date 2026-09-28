# Spencer skládá ověřenou časovou osu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pretty Little Liars**

Spencer skládá časovou osu z několika exportů zpráv a poznámek. Stejná stopa se k ní dostala od Hanny i od Arie, jen v jiném pořadí. V Rosewoodu už pouhá rychlost přeposílání stačí k tomu, aby původní událost vypadala pozdější.

První program vezme náhodnou kopii a některé neověřené záznamy postaví na roveň potvrzeným. Spencer chce vidět nejstarší doložený čas každé stopy. Jinak by plán dalšího pátrání určovalo pořadí souborů místo toho, co se podařilo skutečně zjistit.

</details>
<!-- aiva-story:end -->

Spencer Hastings má několik importů týchž stop. Do časové osy patří jen ověřené záznamy a pro stejné ID nejdřívější ověřený čas, ne první náhodně načtená kopie.

## Tvůj zásah

Oprav filtr, slučovací lambdu a komparátor v timeline. Zachovej význam jednotlivých kroků a nedoplňuj mutace vedlejšího seznamu do map.

## Připravené okolí

Main i závěrečný výpis jsou hotové. Collectors.toMap zde přijímá klíč ID, hodnotu Event a pravidlo sloučení dvou hodnot se stejným ID. Toto připravené sestavení stačí opravit na vyznačeném místě. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet záznamů 0–40 a trojice ID (slovo), minuta 0–1439, ověření true/false. Odstraň neověřené, pro každé ID ponech nejnižší minutu, potom seřaď podle minuty a při shodě podle ID. Vypiš id@minuta, nakonec Pocet a Rozpeti (poslední-první minuta, pro 0 či 1 položku 0). Vstupní seznam neměň.

Ukázkový vstup:

```text
4 A 100 true B 90 true A 80 true C 60 false
```

Očekávaný výstup:

```text
A@80
B@90
Pocet: 2
Rozpeti: 10
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
