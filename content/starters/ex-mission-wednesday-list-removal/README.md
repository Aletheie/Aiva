# Wednesday po úklidu stále vidí chybnou stopu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Wednesday**

Wednesday prochází pracovní poznámky z Nevermore a vyřazuje nedoložené dohady. Enid tvrdí, že jeden z nich byl alespoň nápaditý, ale Wednesday trvá na čistém seznamu. Po spuštění úklidu však některé podezřelé položky zůstanou.

Všimne si, že problém vzniká hlavně tehdy, když byly dvě vedle sebe. Thing přesune papírky na stole a naznačí, co se po odstranění první poznámky stane s ostatními. Wednesday teď chce stejný pohyb sledovat uvnitř programu.

</details>
<!-- aiva-story:end -->

Wednesday čistí pracovní seznam poznámek. Když jsou dva neověřené záznamy za sebou, první zmizí a druhý v seznamu zůstane. Potřebuje zjistit, co udělalo odebrání s indexy.

## Tvůj zásah

Oprav clean(List<Note> working). Nejprve v debuggeru sleduj index a délku po remove při dvou vadných sousedech. Je v pořádku postupovat odzadu nebo použít vhodnou kolekční operaci; důležité je nepřeskočit položku.

## Připravené okolí

Main už vytvořil pracovní kopii seznamu a obstará výpis. Tato metoda má předaný pracovní seznam skutečně změnit. Note je neměnný záznam text()/verified(). Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet poznámek 0–20, potom u každé celý text na řádku a true/false na dalším. Z předaného pracovního List odstraň neověřené poznámky i poznámky s prázdným či bílým textem. Ostatní texty a jejich pořadí zachovej. Vrať skutečný počet odebraných. Main vypíše Odebrano a seznam zbývajících textů.

Ukázkový vstup:

```text
3
A
false
B
false
C
true
```

Očekávaný výstup:

```text
Odebrano: 2
Zbyva: [C]
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
