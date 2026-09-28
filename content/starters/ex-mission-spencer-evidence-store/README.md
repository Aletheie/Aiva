# Spencer mění úložiště, přehled zůstává

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pretty Little Liars**

Spencer chce ověřit, jak se přehled stop chová i v den, kdy nemá žádné důkazy. Hanna souhlasí, že by to byla příjemná změna. Skutečný archiv zpráv z Rosewoodu proto při zkoušce nahradí prázdnou zkušební verzí.

Na obrazovce se přesto objeví původní záznamy. Program si pro ně sáhl jinudy, než Spencer zamýšlela. Spencer potřebuje zjistit, odkud přehled původní záznamy bere, když má pracovat s prázdným úložištěm.

</details>
<!-- aiva-story:end -->

Spencer Hastings chce stejný přehled nad skutečným archivem i prázdnou zkušební implementací. Služba nesmí obejít předané rozhraní a číst původní mapu bokem.

## Tvůj zásah

Doplň Report.print(String[] ids,EvidenceStore store). Používej jen store.find; s nenalezeným záznamem zacházej před přístupem k verified().

## Připravené okolí

MemoryStore a EmptyStore už implementují stejné rozhraní. Mapu i parsování vstupu obstarává main; pro tvůj kód stačí find vracející Entry nebo null. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: MEMORY nebo EMPTY, počet záznamů 0–20, dvojice ID/ověření true-false, počet dotazů 0–20 a jejich ID. ID jsou slova bez mezer, uložená ID jedinečná. Vypiš každý dotaz jako id:true, id:false nebo id:? při nenalezení. Nakonec Potvrzene: X, počet potvrzených dotazů; opakovaný dotaz se počítá znovu. EMPTY nic nenajde ani při připravených datech.

Ukázkový vstup:

```text
MEMORY 2 A true B false 3 A C B
```

Očekávaný výstup:

```text
A:true
C:?
B:false
Potvrzene: 1
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
