# Holmes potřebuje časovou osu, které může věřit

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Sherlock Holmes · současná variace**

Na stole v Baker Street leží původní svědectví, jeho oprava a zpráva, která starší tvrzení výslovně odvolává. Watson chce sepsat přehled případu. Holmes upozorní, že vypsat všechny papíry v pořadí příchodu by vytvořilo velmi přesvědčivý nesmysl.

Digitální přehled má zachovat jen použitelné podklady a uspořádat jejich časovou osu. Každý záznam je potřeba posoudit v souvislosti s ostatními. Watsonův další text má stát na tom, co o případu platí teď, ne na všem, čemu se kdy chvíli věřilo.

</details>
<!-- aiva-story:end -->

Sherlock Holmes předává Watsonovi podklady k případu. Některé stopy jsou opravené, jiné neověřené a některé už byly odvolané. Pomoz z nich sestavit použitelný přehled, ne jen vypsat všechno, co dorazilo.

## Tvůj zásah

Doplň CaseReview.timeline. Rozděl si postup na validaci, výběr poslední opravy, vyřazení odvolaných ID a řazení. Můžeš kombinovat běžné cykly a streamy podle čitelnosti.

## Připravené okolí

Main načítá data a Reporter dělá výstupní formát. Clue je neměnný záznam s metodami id(), minute(), place(), confirmed(). Opravuješ jedinou službu; parsování a tisk zachovej. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet záznamů 0–30; u každého ID, minuta, místo a true/false na samostatných řádcích. Potom počet odvolaných ID a tato ID po řádcích. Ořízni ID a místo trimem, velikost písmen zachovej. Platná stopa má obě hodnoty neprázdné, minutu 0–1439 a confirmed=true. Pro stejné ID platí poslední PLATNÁ stopa v pořadí vstupu; pozdější neplatný záznam ji neruší. Odvolaná ID také trimuj a úplně vyřaď. Výsledek seřaď podle minuty, při shodě podle ID. Reporter doplní počty podle míst a časové rozpětí. Zdrojový seznam nepřepisuj.

Ukázkový vstup:

```text
5
A
60
Station
true
B
30
Library
true
 A 
20
 Library 
true
A
99
Wrong
false
C
10
Park
true
1
 C 
```

Očekávaný výstup:

```text
20:A:Library
30:B:Library
Mista: {Library=2}
Rozpeti: 10
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
