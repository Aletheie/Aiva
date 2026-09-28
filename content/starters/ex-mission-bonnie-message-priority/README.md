# Bonnie sjednocuje termíny odpovědí

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Upíří deníky**

Bonnie porovnává rodinné zápisky s dotazy z archivu Mystic Falls. Některé zprávy mohou počkat, u jiných záleží na rychlé odpovědi. Caroline navrhne přehledné priority s popiskem a lhůtou.

Jakmile Bonnie změní naléhavost jedné zprávy, stejná lhůta se podivně objeví i u ostatních. Z celé korespondence se stane jedna velká pohotovost. Bonnie potřebuje, aby změna naléhavosti jedné zprávy neovlivnila lhůty u ostatních.

</details>
<!-- aiva-story:end -->

Bonnie Bennett koordinuje místní archiv. Priorita zprávy má určit popisek i lhůtu; teď poslední použitá priorita přepisuje údaje ostatních.

## Tvůj zásah

Oprav enum Priority: jeho pole, konstruktor a přístupové metody. Výpočet přechodu přes půlnoc v main ponech.

## Připravené okolí

ValueOf vybírá platnou konstantu ze vstupu. Připravený výpis používá label() a delay(); žádná datumová knihovna není potřeba. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Na vstupu je LOW, NORMAL, URGENT nebo IMMEDIATE a minuta přijetí 0–1439. Enum nese popisek a odklad: LOW Odlozena/120, NORMAL Bezna/30, URGENT Nalehava/5, IMMEDIATE Okamzita/0. Main vypíše popisek a termín jako počet dní od přijetí a minutu v daném dni. Každá konstanta musí mít vlastní údaje.

Ukázkový vstup:

```text
NORMAL 1430
```

Očekávaný výstup:

```text
Druh: Bezna
Den: 1
Minuta: 20
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
