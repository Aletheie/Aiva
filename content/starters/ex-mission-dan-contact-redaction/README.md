# Dan zveřejní doménu, ne cizí adresu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Gossip Girl**

Dan pomáhá s malým literárním newsletterem v Brooklynu. Redakce chce zveřejnit přehled, odkud přicházejí čtenářské reakce, a on si vytáhne seznam kontaktních adres. Po zkušenostech s klepy z Upper East Side dobře ví, jak rychle se soukromá informace utrhne ze řetězu.

Zkušební výpis ale ukáže i celé osobní adresy. Serena si toho všimne ještě před zveřejněním. Přehled má popsat redakční statistiku; čtenáři si kvůli zaslanému názoru žádnou nevyžádanou publicitu neobjednali.

</details>
<!-- aiva-story:end -->

Dan Humphrey chystá přehled kontaktních adres pro redakci. Ve veřejném výpisu má zůstat jen doména a délka skryté části. Připravený výpis omylem odhaluje celé adresy.

## Tvůj zásah

Doplň očištění, rozdělení a sestavení veřejného výpisu. Původní adresu nikde nevypisuj.

## Připravené okolí

Scanner předal raw. Locale.ROOT v připravených importech určuje stabilní převod písmen, jeho implementaci nemusíš znát. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Jeden řádek obsahuje adresu s právě jedním @, neprázdnou částí před i za ním, bez vnitřních mezer. Okraje mohou mít mezery. Vypiš ***@ následované doménou malými písmeny a na dalším řádku počet znaků skryté části. Jde o práci s textem, nikoli obecnou validaci e-mailů.

Ukázkový vstup:

```text
  dan.h@Example.COM  
```

Očekávaný výstup:

```text
Kontakt: ***@example.com
Skryto znaku: 5
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
