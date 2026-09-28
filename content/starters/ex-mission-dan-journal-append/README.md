# Dan přidává zápis do deníku

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Gossip Girl**

Dan si po návratu do Brooklynu zapisuje postřehy z večera na Upper East Side. Jeden rozhovor by se hodil do povídky, druhý možná do kapitoly a třetí by raději neměl nikdo poznat. Každý den přidává další odstavec.

Po novém uložení však najde jen poslední poznámku. Zbytek deníku zmizel, přestože program oznámil úspěch. Dan potřebuje způsob zápisu, který naváže na staré texty a zvládne i úplně první stránku, když soubor ještě není připravený.

</details>
<!-- aiva-story:end -->

Dan Humphrey si ukládá poznámky do textového souboru. Nový zápis nyní přepíše celý deník. Oprav jen ukládací metodu a ověř i první zápis, kdy soubor ještě neexistuje.

## Tvůj zásah

Oprav Journal.append(Path file,String entry). Použij režim připojení místo přepsání, explicitní UTF-8 a kontrolu před zápisem.

## Připravené okolí

Main vytváří skutečný soubor v dočasné testovací složce, načte jeho obsah po operaci a složku uklidí. Připravenou třídu Fixture, Scanner ani kontrolní výpis neupravuj; vlastní deník není potřeba. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

První řádek je počet existujících zápisů 0–5, následují jejich řádky a jeden nový zápis. Starší řádky jsou neprázdné. Nový očisti na okrajích; prázdný odmítni IllegalArgumentException bez změny souboru. Platný připoj jako nový řádek v UTF-8. Chybějící soubor vytvoř. Main vypíše výsledek, existenci souboru, počet řádků a každý řádek s prefixem |.

Ukázkový vstup:

```text
2
Pondeli
Utery
 Streda 
```

Očekávaný výstup:

```text
ULOZENO
Soubor: true
Radky: 3
|Pondeli
|Utery
|Streda
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
