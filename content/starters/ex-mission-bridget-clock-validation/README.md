# Bridget nechce schůzku ve 25:70

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Deník Bridget Jones**

Bridget přepisuje termíny z pracovních poznámek do kalendáře. Jedna zpráva obsahuje jiný oddělovač, další slibuje schůzku v čase, který by možná vyhovoval jen po velmi dlouhém večírku. Aplikace oběma věří stejně málo, ale nevysvětlí proč.

Bridget potřebuje poznat, zda má opravit samotný zápis, nebo se zeptat na skutečnou hodinu. Pokud program přijme 25:70, žádný pečlivě vedený deník už ji na takové setkání včas nedostane.

</details>
<!-- aiva-story:end -->

Bridget Jones importuje časy setkání. Program má rozlišit špatně zapsaný čas od dobře zapsaného času, který nemůže existovat.

## Tvůj zásah

Oprav Clock.read(String text): použij připravené Parts.read, ověř oba rozsahy a vrať celkový počet minut. Nevypisuj uvnitř metody a nezaměň chybné hodnoty za nulu.

## Připravené okolí

Parts.read obsahuje hotový regulární výraz a převod čísel. Při chybném formátu vyhazuje NumberFormatException. Ty pro rozsah vyhoď IllegalArgumentException; jejich zachytávání je hotové v main. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet řádků 0–20 a časy. Okrajové mezery jsou povolené. Formát je přesně HH:mm se dvěma číslicemi na každé straně. Platné hodiny 0–23 a minuty 0–59 převeď na minuty od půlnoci. Main vypíše OK: n, FORMAT při chybném zápisu a ROZSAH při neplatných hodnotách; po chybě pokračuje.

Ukázkový vstup:

```text
4
09:30
25:70
9:30
00:00
```

Očekávaný výstup:

```text
OK: 570
ROZSAH
FORMAT
OK: 0
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
