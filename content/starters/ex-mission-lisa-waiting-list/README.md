# Lisa udržuje pořadí čekatelů

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Simpsonovi**

Lisa vede čekací listinu na oblíbený školní program. Míst je málo a přihlášky chodí rychle. Bart zkusí odeslat stejnou žádost několikrát a potom tvrdí, že musí být v pořadí blíž, když projevil tolik zájmu.

Lisa mu nechce pokaždé odpovídat osobně. Potřebuje seznam, který zachová pořadí, nepřijme opakovanou přihlášku jako novou výhodu a umí se vypořádat i s odchodem a pozdějším návratem. Férové čekání by mělo přežít i Bartovu tvořivost.

</details>
<!-- aiva-story:end -->

Lisa Simpson spravuje čekací listinu. Opakované přihlášení nemá člověka předběhnout a zrušená žádost se po novém přihlášení zařadí na konec.

## Tvůj zásah

Oprav WaitingList s kolekcí zachovávající pořadí. Změny prováděj jen při úspěchu a nevracej seznam, který by klient mohl přímo přepsat.

## Připravené okolí

Main předává příkazy čekací listině a vypisuje její aktuální obsah. ArrayList nabízí contains, add, remove a isEmpty; List.copyOf vytvoří neměnitelnou kopii seznamu. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet akcí 0–30, pak ADD jméno, CANCEL jméno nebo NEXT. Jména jsou neprázdná slova bez mezer a nejsou znak -. ADD vrací true jen pro nové jméno; duplicita nemění pořadí. CANCEL vrací true jen při odebrání. NEXT vrátí a odebere prvního čekajícího, nebo - při prázdné frontě. Main vypíše výsledky akcí a zbývající pořadí.

Ukázkový vstup:

```text
6 ADD Bart ADD Lisa ADD Bart CANCEL Bart ADD Bart NEXT
```

Očekávaný výstup:

```text
true
true
false
true
true
Lisa
Cekaji: [Bart]
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
