# Kam zmizel rozpočet na festival?

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

Nela se vrací z festivalu s fotkami, programem plným poznámek a kapsou účtenek. Ema si pamatuje skvělé jídlo, Lea drahou cestu a všechny tři tvrdí, že utratily přibližně totéž. Jejich odhady se ovšem výrazně liší.

Nela chce mít příští společný plán opřený o skutečné částky. Potřebuje průběžně zapisovat výdaje a kdykoli zjistit součet. Malá konzolová evidence jí umožní přestat hledat poslední platbu mezi fotografiemi kapel a zprávami z festivalové fronty.

</details>
<!-- aiva-story:end -->

Nela se vrací z festivalu. Fotek má dost, přehled o výdajích už méně. Postav jí malou konzolovou evidenci, do které přidá jednotlivé útraty a kdykoli zjistí jejich součet. „Asi tak dvě stovky“ už nebude jediný podklad.

## 1. Dva výdaje

Vytvoř typ `Expense` s nezápornou částkou typu `long` v haléřích a kategorií. Ulož dva výdaje do `List<Expense>` a sečti je. Data zatím zůstávají jen v paměti.

## 2. Příkazy

Přidej `pridej HALERE KATEGORIE`, `seznam`, `soucet` a `konec`. Například `pridej 1250 Jidlo` uloží 12,50 Kč. Kategorie může obsahovat mezery.

Neplatnou částku nebo prázdnou kategorii odmítni a dovol další příkaz. Vzorový `record` můžeš nahradit běžnou třídou.

## Vyzkoušej

Prázdný seznam má součet 0. Částky 1250 a 3999 dají 5249. Záporná částka a text místo čísla nesmějí přidat záznam. Kategorie s mezerou se vypíše celá.

**Dobrovolně navíc:** součet podle kategorií nebo smazání výdaje. Ukládání do souboru přijde v dalším projektu.

## Použité nástroje a jejich výklad

Record a kompaktní konstruktor, split a substring, Math.addExact a částky a kolekce.

## Kontrola

- [ ] Výdaj je samostatný typ.
- [ ] Více výdajů je uložených v List.
- [ ] Částky se sčítají jako celé haléře.
- [ ] Chybné vstupy nevytvářejí neplatný záznam.
- [ ] Prázdný seznam vrací součet 0.
