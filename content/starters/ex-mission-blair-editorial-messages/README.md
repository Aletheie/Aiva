# Blair přidává opravu do redakčního přehledu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Gossip Girl**

Blair sestavuje přehled oznámení k benefičnímu večeru. Serena pošle změnu času, Dan upozorní na chybu v již vydaném textu. Oprava potřebuje znít jinak než čerstvá pozvánka, jinak ji hosté snadno přehlédnou.

Společný výpis se začíná plnit zvláštními podmínkami pro každou variantu. Blair chce, aby každé oznámení vědělo, jak se má představit, a přehled je dokázal prostě zveřejnit.

</details>
<!-- aiva-story:end -->

Blair Waldorf připravuje redakční přehled oznámení. Nové oznámení a oprava mají jiná pravidla textu, ale jejich společný výpis se kvůli tomu nemá rozrůstat o další podmínky.

## Tvůj zásah

Doplň třídy Publication a Correction. Zachovej společný cyklus v main a nepřidávej do něj instanceof ani větvení podle druhu zprávy.

## Připravené okolí

Abstraktní Message uchovává normalizovaný titulek a poskytuje title(). Hotový cyklus volá pouze text(); správnou implementaci vybere skutečný objekt. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Dva řádky: neprázdný titulek po trim a důvod opravy, který smí být prázdný. Publication.text vrátí NOVY: titulek. Correction.text vrátí OPRAVA: titulek / důvod s oříznutými okraji; prázdný důvod místo toho vrátí NEUPLNA OPRAVA: titulek. Main oba objekty vypíše přes společný typ Message.

Ukázkový vstup:

```text
 Vecirek 
 Zmena casu 
```

Očekávaný výstup:

```text
NOVY: Vecirek
OPRAVA: Vecirek / Zmena casu
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
