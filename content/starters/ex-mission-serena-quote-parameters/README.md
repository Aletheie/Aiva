# Serena porovnává dvě nabídky

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Gossip Girl**

Serena slíbila obstarat pozvánky na další akci a přinesla dvě nabídky tiskárny. Blair už posuzuje papír, písmo i to, zda jedna z barev nepůsobí příliš všedně. Serena mezitím chce alespoň porovnat ceny.

Kalkulačka ale u obou nabídek vrátí stejný výsledek. Uvnitř zůstala hodnota z první zkoušky, takže změna dodavatele na obrazovce nic nezmění. Než se debata přesune k obálkám, potřebuje Serena program, který skutečně počítá s nabídkou, kterou právě dostal.

</details>
<!-- aiva-story:end -->

Serena van der Woodsen porovnává dvě nabídky tiskárny pro pozvánky. Výpočet nesmí použít skrytou pevnou cenu z předchozí zakázky a sazba slevy se musí vztahovat ke správné nabídce.

## Tvůj zásah

Oprav práci s parametry v printQuote(int base,int percent). Žádnou nabídku nevkládej napevno a při druhém volání nepoužívej cenu z prvního.

## Připravené okolí

Načtení, dvě volání metody a výpis původních cen už jsou připravené. Parametry jsou místní hodnoty konkrétního volání. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: dvě základní ceny 0–100000 a procentní sleva 0–100. Main zavolá printQuote pro každou cenu se stejným procentem. Metoda vypíše Sleva: X a Nabidka: Y. Slevu zaokrouhli dolů na celé koruny celočíselným dělením až po násobení. Main nakonec vypíše původní ceny, které zůstanou stejné.

Ukázkový vstup:

```text
199 501 10
```

Očekávaný výstup:

```text
Sleva: 19
Nabidka: 180
Sleva: 50
Nabidka: 451
Puvodni: 199,501
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
