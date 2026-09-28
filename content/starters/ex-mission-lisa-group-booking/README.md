# Lisa nepřijme půlku skupiny

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Simpsonovi**

Lisa připravuje veřejnou debatu ve springfieldské knihovně. Přicházejí celé skupiny ze školy a chtějí sedět spolu. Bart se zatím ptá, zda se počítá i jeho imaginární doprovod, ale Lisa má naléhavější problém.

Rezervační aplikace odmítne skupinu, která se nevejde, a přesto jí odečte místa. Sál je na obrazovce skoro plný, zatímco židle zůstávají prázdné. Lisa chce dát další přihlášce férovou šanci, místo aby bojovala s hosty, kteří existují pouze v chybném součtu.

</details>
<!-- aiva-story:end -->

Lisa Simpson zapisuje skupiny na veřejnou debatu. Program má odmítnout skupinu, která se nevejde celá, a při odmítnutí nesmí ubrat žádná místa.

## Tvůj zásah

Oprav větvení a okamžik změny reserved. Včetně odmítnutí musí vzniknout právě jeden stavový řádek a jeden řádek kapacity.

## Připravené okolí

Main načte capacity, reserved a requested. Pracuješ s existujícím stavem, vstup ani formát následného výpisu kapacity neměň. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: kapacita, dosud rezervovaná místa a nová žádost. Kapacita je 0–1000, rezervace 0 až kapacita, žádost 0–1000. Nulová žádost vrací NEPLATNA; kladná, která se vejde, POTVRZENA; větší CEKACI. Na druhém řádku vypiš Volno: X po operaci. Pouze potvrzení mění počet rezervací.

Ukázkový vstup:

```text
10 7 3
```

Očekávaný výstup:

```text
POTVRZENA
Volno: 0
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
