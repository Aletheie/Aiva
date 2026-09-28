# Sally skládá cenu skupinové večeře

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Když Harry potkal Sally**

Sally objednává večeři pro větší skupinu a restaurace jí poslala nabídku menu, skupinové zvýhodnění i kupón. Harry prohlásí, že sleva je prostě sleva. Sally si okamžitě všimne, že pořadí výpočtu mění konečnou částku.

Na stole přibývají poznámky a každá verze účtu slibuje jinou cenu. Sally chce zavolat do restaurace s jedním ověřeným číslem. Potřebuje proto výpočet, který pokaždé uplatní slevy ve stejném pořadí.

</details>
<!-- aiva-story:end -->

Sally Albright chce jednu metodu, která spočítá menu, skupinovou slevu i kupón. Slevy se musí uplatnit ve správném pořadí a výsledná cena nesmí být záporná.

## Tvůj zásah

Doplň priceForGroup, která použije hotovou pomocnou metodu discountPercent. Uvnitř nic nevypisuj.

## Připravené okolí

Main obstará vstupy a výpis. Implementace discountPercent je připravená; stačí znát její argument a výsledek. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet lidí 1–20, cena jídla a pití 0–1000, kupón na celou objednávku 0–100000. Základ je people*(meal+drink). Připravená discountPercent vrací 0 % do tří lidí, 5 % pro 4–7 a 10 % od osmi. Procentní slevu zaokrouhli dolů, potom odečti kupón a výsledek omez na nejméně nulu. Vrať int.

Ukázkový vstup:

```text
4 100 25 50
```

Očekávaný výstup:

```text
425
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
