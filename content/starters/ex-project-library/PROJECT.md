# Hermionin knižní klub

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Harry Potter**

Hermiona založila knižní klub a přinesla do společenské místnosti i své oblíbené mudlovské knihy. Ron si půjčil jeden výtisk, Harry se ptá po stejném a na stole leží lístek s poznámkou, kterou už nikdo neumí přiřadit ke správné knize.

Hermiona chce katalog, který udrží přehled o knihách a jejich výpůjčkách i po zavření programu. Každý výtisk má být dostupný jen tehdy, když skutečně leží v klubové polici.

</details>
<!-- aiva-story:end -->

Hermiona rozjíždí knižní klub a nechce lovit výpůjčky v paměti. Pomoz jí postavit katalog, který rozezná volnou a půjčenou knihu, nedovolí půjčit jeden výtisk dvěma lidem a nezapomene stav po restartu.

## 1. Pravidla knihy

Starter obsahuje `Book`, `LoanState` a `BookRepository` s paměťovým úložištěm. Kniha má stálé ID, název a stav `AVAILABLE` nebo `BORROWED`.

Odmítni duplicitní ID, půjčení vypůjčené knihy a vrácení nevypůjčené. Přidej vlastní výjimku pro porušení pravidla.

## 2. Příkazy a soubor

Doplň přidání, seznam, vypůjčení, vrácení a uložení. Souborové úložiště má stejné rozhraní jako paměťové. Konzolové příkazy nemají řešit formát souboru.

Zapisuj nejprve do dočasného souboru vedle cíle; nahraď ho až po úspěchu. Chybu zápisu oznam. V TSV zakaž tabulátory a nové řádky v názvech.

## Vyzkoušej

Ověř všechny zakázané operace, načtení po restartu, poškozený soubor a chybu zápisu. Hlášení „uloženo“ smí přijít až po úspěšném zápisu.

V README uveď, že aplikace je lokální pro jeden běžící proces. Server ani grafické rozhraní nejsou potřeba.

## Použité nástroje a jejich výklad

Zapouzdření a invariant, enum, rozhraní a soubory. IllegalStateException znamená, že operace není dovolena v aktuálním stavu, například opakovaná výpůjčka.

## Kontrola

- [ ] Stavy modeluje enum a přechody hlídá doména.
- [ ] Úložiště má interface a dvě zaměnitelné implementace.
- [ ] Duplicitní ID a neplatné operace jsou odmítnuté.
- [ ] Soubory přežijí restart.
- [ ] Neúspěšné uložení není vydáváno za úspěch.
