# Marge chce jeden srozumitelný účet

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Simpsonovi**

Po sousedském občerstvení leží na kuchyňském stole účtenky, záznam o záloze a Homerova poznámka, že „to určitě vyjde“. Marge potřebuje rozeslat vyúčtování, takže ji tento druh účetní jistoty příliš neuklidňuje.

Jedna část programu vypočte cenu, druhá přijatou platbu a třetí z nich vytiskne zprávu, které rozumí pokaždé trochu jinak. Marge chce jeden čitelný účet: ať zákazník hned vidí, zda ještě něco doplácí, nebo se mu část peněz vrací.

</details>
<!-- aiva-story:end -->

Marge potřebuje na pokladně odlišit cenu celé objednávky, už zaplacenou část a to, zda má vracet nebo ještě vybírat doplatek. Připravená pokladna umí data dodat; nefunguje její závěrečná zpráva.

## Tvůj zásah

Doplň void metodu printReceipt(). V ní použij hotové cash.total() a cash.paid(), vypočítej rozdíl a zvol správnou zprávu.

## Připravené okolí

Cash je připravená třída a cash je její připravený objekt. Nemusíš ještě umět psát konstruktor ani instanční pole; rozhraní poskytuje dvě celá čísla. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup jsou dvě nezáporná čísla do 100000: cena a zaplacená částka. Vypiš Celkem: X a Zaplaceno: Y, potom buď Doplatit: rozdíl při nedoplatku, nebo Vratit: rozdíl při dostatečné platbě. Přesná platba má Vratit: 0. Každé volání má právě tři řádky.

Ukázkový vstup:

```text
650 1000
```

Očekávaný výstup:

```text
Celkem: 650
Zaplaceno: 1000
Vratit: 350
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
