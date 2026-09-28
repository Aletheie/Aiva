# Wednesday potřebuje ověřený přehled stop

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Wednesday**

Na nástěnce v pokoji v Nevermore přibyly fotografie, poznámky a jeden velmi podezřelý papírek, který dodala Enid. Thing upozorní na dvě stopy, jejichž původ se dá doložit. Zbytek zatím tvoří směs pozorování a studentských klepů.

Wednesday si nechá vypsat přehled a zjistí, že program mluví o všech položkách se stejnou jistotou. To je na její vkus příliš optimistické. Chce si před dalším krokem přečíst stručné shrnutí toho, co je opravdu potvrzené, včetně toho, co zatím neví.

</details>
<!-- aiva-story:end -->

Wednesday Addams má nástěnku stop, ale automatická zpráva směšuje potvrzené informace s domněnkami. Oprav jen tvorbu přehledu, ne celou evidenci.

## Tvůj zásah

Oprav metodu printBriefing(). Má nic nevracet, ale sestavit celý přehled jedním průchodem. Je volaná připraveným main.

## Připravené okolí

Třídu Board zatím nemusíš znát. Její rozhraní: board.size() vrátí počet položek, labelAt(i) text a isConfirmedAt(i) stav položky s indexem i od nuly. Pole a konstruktor nástěnky ponech. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet stop 0–20, potom pro každou název na řádku a true/false na dalším řádku. Vypiš POTVRZENE, potom pouze potvrzené názvy v původním pořadí a nakonec Pocet: X. Nepotvrzená stopa se nezapočítává ani nevypisuje. Hlavička a součet vzniknou i pro prázdnou nástěnku.

Ukázkový vstup:

```text
3
Klic
true
Povest
false
Dopis
true
```

Očekávaný výstup:

```text
POTVRZENE
Klic
Dopis
Pocet: 2
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
