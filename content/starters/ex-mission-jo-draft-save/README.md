# Jo nesmí přijít o poslední uložený rukopis

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Malé ženy · současná variace**

Jo pracuje na další verzi rukopisu a Amy právě dočetla poslední uloženou kopii. V této současné variaci mají texty vlastní složku a Jo už nemusí každou stránku opisovat. To ovšem neznamená, že by chtěla o všechny přijít najednou.

Zkušební zápis nové verze se přeruší uprostřed. Jo potřebuje mít pořád čitelný poslední hotový rukopis, i když se další uložení nepodaří. Nedokončená pracovní kopie může počkat; předchozí večery psaní musejí zůstat zachované.

</details>
<!-- aiva-story:end -->

Jo March ukládá novou verzi rukopisu. Zápis se může přerušit před nahrazením staré verze; při takové chybě musí zůstat stará verze čitelná a dočasný soubor se má uklidit.

## Tvůj zásah

Doplň DraftStore.save(Path file,String text,Replacer replacer). Přímý zápis do cílového souboru je právě chyba, kterou hledáš.

## Připravené okolí

Replacer je připravená závislost: buď soubor nahradí, nebo před nahrazením vyhodí IOException. Main připravuje skutečné soubory a uklízí testovací složku. Těmto pomocným částem zatím nemusíš rozumět. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Tři řádky: starý text, nový text a true/false pro simulovanou chybu nahrazení. Prázdný nebo pouze bílý nový text odmítni IllegalArgumentException před zápisem. Jinak nový text zachovej přesně včetně okrajových mezer. Zapiš ho do dočasného souboru vedle cíle, zavolej replacer.replace a dočasný soubor vždy uklidť. IOException propaguj. Main ověří obsah původního souboru i počet zbylých dočasných souborů. Model ověřuje chybu před nahrazením, nikoli odolnost vůči výpadku celého disku.

Ukázkový vstup:

```text
Verze 1
Verze 2
false
```

Očekávaný výstup:

```text
OK
Obsah: Verze 2
Docasne: 0
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
