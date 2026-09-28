# Burnsova evidence přeskakuje čísla průkazů

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Simpsonovi**

Smithers připravuje návštěvnické průkazy pro elektrárnu. Pan Burns žádá přesnou evidenci, zatímco Homer zkouší, zda automat vydá kartičku i bez jména. Přístroj žádost odmítne, ale číslo jako by se přesto spotřebovalo.

Navíc nový návštěvník přepíše jméno na starším průkazu. Smithers si představí vysvětlování u vstupní brány a raději zastaví tisk. Potřebuje číslovat skutečně vydané kartičky a zachovat, komu každá z nich patří.

</details>
<!-- aiva-story:end -->

Pan Burns chce přehled skutečně vydaných návštěvnických průkazů. Zamítnuté prázdné jméno nemá spotřebovat číslo a nový průkaz nesmí přepsat vlastníka předchozího.

## Tvůj zásah

Oprav statické počítadlo a instanční údaje v Badge. Inkrement se má provést až po validaci.

## Připravené okolí

Main zná null jako odmítnutí a vlastní průkazy nijak nemění. Soukromý konstruktor se volá jen z tovární metody issue. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Počet žádostí 0–20 je na prvním řádku, pak jména po řádcích. issue očistí jméno trim. Prázdné odmítne hodnotou null. Přijaté žádosti dostávají čísla 1,2,... bez mezer. Dvě různá vydání stejného jména jsou dva průkazy. Main při načítání ihned vypíše ODMITNUTO za každou odmítnutou žádost. Po načtení všech žádostí vypíše přijaté průkazy jako id:owner v pořadí vydání a nakonec Vydano: X.

Ukázkový vstup:

```text
3
 Lisa 
   
Marge
```

Očekávaný výstup:

```text
ODMITNUTO
1:Lisa
2:Marge
Vydano: 2
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
