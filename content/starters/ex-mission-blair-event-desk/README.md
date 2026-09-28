# Blair třídí hosty u tří přepážek

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Gossip Girl**

Blair rozdělila vstup na benefiční večer mezi několik přepážek. Novináři mají vlastní místo, běžní hosté jiné a organizační tým potřebuje projít bez bloudění mezi fotografy. Serena právě přivádí další skupinu.

Na jedné vstupence se objeví označení, které aplikace nezná. Program se tváří, že to určitě bude normální host. Blair si představí titulky o náhodném člověku v zákulisí a okamžitě přeruší generálku: i neznámý údaj musí dostat promyšlenou odpověď.

</details>
<!-- aiva-story:end -->

Blair Waldorf má na akci přepážku pro hosty, tisk a organizační tým. Nový typ vstupenky nesmí omylem spadnout mezi potvrzené hosty.

## Tvůj zásah

Doplň úplný switch a pravidla počtu lidí. Neznámý typ nesmí dostat výchozí přístup hosta.

## Připravené okolí

Scanner, normalizace typu a počet doprovodu jsou připravené. Math.min(a,b) je pomocná funkce vracející menší číslo; můžeš místo ní použít podmínku. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Dva řádky: typ pozvánky a počet doprovodných osob 0–5. Typ nejdřív očisti trim a převeď na velká písmena. VIP patří do SALONEK a zahrnuje hlavního hosta i nejvýše dva z doprovodu. PRESS patří do TISK a přijímá pouze hlavního hosta. GUEST patří do RECEPCE a přijímá hlavního hosta i celý doprovod. Neznámý typ vypíše pouze NEZNAMY TYP. U známého typu vypiš místo a na dalším řádku počet přijatých lidí.

Ukázkový vstup:

```text
 vip 
5
```

Očekávaný výstup:

```text
SALONEK
3
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
