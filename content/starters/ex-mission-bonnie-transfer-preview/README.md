# Bonnie zkouší přesun nanečisto

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Upíří deníky**

Bonnie pomáhá Caroline přerozdělit zásoby mezi dvěma místy v Mystic Falls. Než něco odvezou, chtějí porovnat několik možností. Na stole proto vznikne malý plán: co by kde zůstalo po jednotlivých přesunech.

První náhled však upraví i skutečnou evidenci. Druhý už počítá s přesunem, který se nikdy neuskutečnil. Bonnie odloží zápisník s kouzly; na tuto záměnu stačí obyčejná chyba v programu. Potřebuje si varianty prohlížet, aniž by se krabice na papíře samy stěhovaly.

</details>
<!-- aiva-story:end -->

Bonnie Bennett plánuje přesun zásob mezi dvěma místy. Náhled má ukázat výsledek, ale původní stav musí zůstat použitelný i pro jiný návrh.

## Tvůj zásah

Oprav preview(int[] stock,int from,int to,int amount). Rozhodnutí o platnosti přesunu musí předcházet oběma změnám.

## Připravené okolí

Main vypíše původní pole, náhled a informaci, zda je to stejný objekt. Arrays.toString je jen připravený výpis pole. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: délka pole 1–20, zdrojový index, cílový index, množství 0–1000 a hodnoty zásob 0–1000. Indexy jsou platné. Vrať nové pole. Je-li zdroj i cíl stejný nebo zdroj nemá dost, vrať nezměněnou kopii. Jinak odečti množství u zdroje a přičti u cíle. Původní pole neměň ani při odmítnutí.

Ukázkový vstup:

```text
3 0 2 4 10 1 2
```

Očekávaný výstup:

```text
Puvodni: [10, 1, 2]
Nahled: [6, 1, 6]
Stejne pole: false
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
