# Lisa odděluje zůstatek a měsíční limit

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Simpsonovi**

Lisa spravuje rozpočet školního spolku a chce, aby šlo každou částku zpětně vysvětlit. Bart objeví, že po vrácení peněz může program stejný měsíční limit utratit znovu. Vypadá to jako překvapivě levný způsob financování nekonečných nákupů.

Lisa ale dostala jasné zadání: vrácené peníze se mají objevit na účtu, přehled uskutečněných výdajů zůstává do dalšího období. Potřebuje oddělit dvě různé informace, než Bart svůj „objev“ představí zbytku školy.

</details>
<!-- aiva-story:end -->

Lisa Simpson spravuje cvičný rozpočet spolku. Vrácené peníze zvýší zůstatek, ale už uskutečněné výdaje se mají počítat do limitu až do začátku dalšího období.

## Tvůj zásah

Doplň model Budget se soukromým stavem a správnými přechody. Nepovedený výdaj nesmí zvyšovat čerpání.

## Připravené okolí

Parser příkazů i jejich výpis jsou hotové. Zpracováváš pravidla jedné třídy; nejde o skutečný bankovní systém. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počáteční zůstatek a měsíční limit 0–10000, pak počet akcí 0–20. Akce SPEND n zkusí kladný výdaj, který nepřesáhne zůstatek ani zbývající limit; vrací true/false. CREDIT n má vždy kladné n a zvýší zůstatek bez změny čerpaného limitu. NEW zahájí nové období: vynuluje čerpání, ponechá peníze. Po každé akci se vypíše zůstatek a čerpání. Výdaje mohou být -1 až 10000.

Ukázkový vstup:

```text
100 60 5 SPEND 40 CREDIT 20 SPEND 30 NEW SPEND 30
```

Očekávaný výstup:

```text
Platba: true
60:40
80:40
Platba: false
80:40
80:0
Platba: true
50:30
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
