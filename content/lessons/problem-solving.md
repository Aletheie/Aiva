## Nejdřív jeden konkrétní příklad

Zadání zní: „Spočítej cenu tří vstupenek po 120 Kč.“ Napiš si nejprve očekávaný výsledek: `360`.

Pak rozděl práci:

1. Zjistím počet vstupenek.
2. Zjistím cenu jedné vstupenky.
3. Hodnoty vynásobím.
4. Vypíšu výsledek.

Tomuto zápisu vlastními slovy se někdy říká **pseudokód (pseudocode)**. Nemusí se dát spustit.

## Vyzkoušej jednu změnu

Co když je vstupenek nula? Výsledek má být nula. Co když je počet záporný? Tady musí zadání určit, zda takový vstup vůbec dovoluje.

## Jak poznáš hotový krok

U každého kroku si řekni, co ověříš. „Výpočet funguje“ je vágní. „Pro 3 a 120 dostanu 360“ je konkrétní.

Stejný postup využiješ u projektů: nejdřív malá funkční verze, potom další požadavek.

## Rozlož větší úkol na ověřitelné části

U kalkulačky nejdřív napiš součet dvou pevných čísel. Potom nahraď hodnoty vstupem. Až tento krok funguje, přidej volbu operace. Nakonec řeš neplatnou volbu a dělení nulou. V každé fázi existuje program, který lze spustit a zkontrolovat.

Rozdělení větší práce na menší části se nazývá **dekompozice (decomposition)**. U vstupenek tak můžeš zkoušet výpočet ceny ještě předtím, než program umí číst počet lístků z klávesnice. Nejdřív mu počet napíšeš přímo do kódu. Později oba kroky propojíš a pořád víš, který z nich právě ověřuješ.

## Tabulka příkladů před kódem

| Počet lístků | Cena jednoho | Očekávaný součet |
|---|---|---|
| 3 | 120 | 360 |
| 0 | 120 | 0 |
| 1 | 0 | 0 |
| -1 | 120 | Odmítnutý vstup podle zadání |

Tabulka obsahuje běžný případ, prázdné množství, nulovou cenu a nepřípustnou hodnotu. Nejde o všechny možné kombinace, ale o různé druhy chování. Když výsledky nesouhlasí, zjisti první krok, v němž se skutečný stav liší od očekávaného.

Pro další pokus navrhni rozdělení jízdného mezi cestující. Uveď jednotku částky, pravidlo zaokrouhlení a chování při nule cestujících. Teprve potom napiš výpočet. Když se shodnete na těchto pravidlech, každá účastnice výletu může výsledek sama zkontrolovat.
