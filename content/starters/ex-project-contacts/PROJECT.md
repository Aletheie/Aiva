# Dej dohromady partu na game jam

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Ema skládá tým na víkendový game jam. Lea chce programovat, další zájemkyně kreslit a někdo nabídl hudbu, jenže jeho kontakt zůstal v rychle mizejícím chatu. Ema má v hlavě celou hru, ale ne adresu člověka, který se nabídl jako první.

Potřebuje malý spolehlivý adresář. Kontakty se budou doplňovat, opravovat i vyhledávat a musejí přežít vypnutí počítače. První společný projekt tak začíná ještě před samotnou hrou: dát dohromady lidi, kteří ji mohou vytvořit.

</details>
<!-- aiva-story:end -->

Ema skládá tým na game jam, víkendové tvoření vlastní hry. Jedno jméno má v chatu, druhý e-mail na papírku a třetí si prý určitě zapamatuje. Pomoz jí vytvořit adresář, ve kterém kontakty najde, opraví a uchová i po vypnutí programu.

## 1. Kontakty v paměti

Vytvoř `Contact` a `Map<String, Contact>` podle jména. Přidej příkazy `pridej EMAIL JMÉNO`, `najdi JMÉNO`, `smaz JMÉNO`, `seznam` a `konec`. Stejné jméno nahradí dosavadní kontakt; napiš to do nápovědy.

## 2. Uložení a načtení

Příkaz `uloz` zapíše `contacts.tsv` v UTF-8. Řádek obsahuje jméno, tabulátor a e-mail. V hodnotách zakaž tabulátor a nový řádek; omezení popiš v README.

Chybějící soubor znamená prázdný adresář. Poškozený soubor oznam a zachovej; nepřepisuj ho prázdnými daty.

## Vyzkoušej

Přidej jméno s mezerou a diakritikou, ulož a restartuj. Ověř hledání, nahrazení stejného jména, smazání i nenalezený kontakt. Na kopii souboru zkus poškozený řádek.

**Dobrovolně navíc:** samostatná třída pro ukládání a zápis přes dočasný soubor.

## Použité nástroje a jejich výklad

Map a její operace, textové oddělovače, čtení a zápis UTF-8 a lambda ve výpisu. Vzorový Contact poskytuje name() a email() jako přístupové metody recordu.

## Kontrola

- [ ] Kontakty mají vlastní typ a index v Map.
- [ ] Seznam přežije uložení a restart.
- [ ] UTF-8 zachová diakritiku.
- [ ] Poškozený vstup je nahlášen, ne ignorován.
- [ ] Je známé pravidlo pro duplicitní jména.
