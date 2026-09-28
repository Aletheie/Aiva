# Festivalové výdaje pod lupou

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Nela už festivalové výdaje pečlivě zapisuje. Při plánování další cesty však parta potřebuje víc než dlouhý seznam účtenek: kolik stála doprava, kolik jídlo a kde se objevily větší částky. Ema by ráda věděla, zda rozpočet zachrání méně limonád, nebo jiný spoj.

V exportu je i několik chybných řádků. Nela potřebuje vědět, které údaje má opravit, než začne podle součtů plánovat další výlet.

</details>
<!-- aiva-story:end -->

Nela už si festivalové výdaje zapisuje. Teď chce vědět, kolik spolykala doprava, kolik jídlo a kolik útrat překročilo 50 Kč. Pomoz jí proměnit soubor položek v přehled. Na chybný řádek upozorni, aby v součtu některý výdaj nechyběl.

## 1. Načti data

Starter obsahuje `expenses.csv` se sloupci `category,cents`. Tento jednoduchý formát nemá uvozovky ani čárky uvnitř hodnot. Čtení a ověření řádků odděl od výpočtů.

Chybný řádek oznam s jeho číslem; nevypisuj neúplný součet jako správný výsledek.

## 2. Spočítej přehled

Pomocí Stream API vypiš počet položek, celkový součet, součty kategorií seřazených podle názvu a počet výdajů alespoň 5000 haléřů. V `map` neměň cizí seznam.

## Vyzkoušej

Pro vzorek vyjde: Doprava 3200, Jídlo 8600, součet 11800, počet 3 a jeden výdaj alespoň 5000. Prázdná data mají součet 0. Zkus také chybný řádek.

**Dobrovolně navíc:** filtrování kategorií a nejdražší záznam přes Optional. Pro obecné CSV by byl potřeba plnohodnotný parser.

## Použité nástroje a jejich výklad

Pipeline a součty podle kategorií, lambda a method reference, split a soubory.

## Kontrola

- [ ] Agregace odpovídá vzorku 11800 haléřů.
- [ ] Výstup kategorií je deterministicky seřazený.
- [ ] Prázdná data nezpůsobí dělení nulou.
- [ ] Zpracování dat nemění původní seznam výdajů.
- [ ] Chybný řádek není tiše přeskočený.
