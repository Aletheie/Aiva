# Hanna přesouvá naléhavou návštěvu dopředu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pretty Little Liars**

Hanna má na odpoledne naplánované tři zastávky v Rosewoodu. Spencer potřebuje porovnat poznámky, Aria něco předat a poslední návštěva měla původně klidně počkat. Pak přijde další zpráva od „A“ a pořadí přestane dávat smysl.

Hanna přesune naléhavou zastávku dopředu, ale aplikace přepíše i jednu z ostatních adres. Místo rychlého plánu má dvě totožná místa a jedno ztracené. Potřebuje změnit pořadí návštěv tak, aby cestou nezmizela žádná z nich.

</details>
<!-- aiva-story:end -->

Hanna Marin má v plánu tři návštěvy. Poslední se stala naléhavou, takže má být první; původní první a druhá se posunou o místo. Teď aplikace přepisuje dvě adresy tou samou.

## Tvůj zásah

Oprav přeskupení prvků pole places. Pro záchranu původní hodnoty použij pomocnou proměnnou. Nová jména nevymýšlej.

## Připravené okolí

Vytvoření pole a závěrečný průchod pro výpis jsou připravené. Stačí pracovat s indexy 0, 1 a 2, cyklus upravovat nemusíš. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Tři řádky jsou názvy míst, včetně případných mezer. Pole má vždy právě tři prvky. Z pořadí A,B,C vytvoř C,A,B a zachovej i případná stejná jména. Vypiš prvky každý na vlastním řádku.

Ukázkový vstup:

```text
Knihovna
Kavarna
Stanice
```

Očekávaný výstup:

```text
Stanice
Knihovna
Kavarna
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
