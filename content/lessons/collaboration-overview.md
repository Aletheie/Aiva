## Než začnete pracovat společně

Jedna z vás přidává ukládání kontaktů, druhá kontrolu jména. Aby šly změny spojit, potřebujete se shodnout, jak kontakt vypadá a zda smí mít jméno prázdné. Do README si zapište také potřebné JDK a příkaz pro testy. [Git](lesson:git-overview) pomůže spojit historii, ale tuto dohodu za vás nevymyslí.

GitHub nazývá návrh změny **pull request (PR)**, GitLab **merge request (MR)**. V obou případech jde o porovnání větve a diskuzi před začleněním. **Code review** je kontrola kódu jiným členem týmu: ověřuje chování, srozumitelnost a testy, nikoli autora změny.

## Konkrétní pracovní cyklus

Předpokládejme již naklonovaný projekt s `origin` a větví `main`. Začínej s čistým pracovním stromem; `status` musí být srozumitelný.

```sh
git switch main
git pull --ff-only
git switch -c feature/contact-validation
mvn test
```

První dva příkazy přepnou a aktualizují hlavní větev, třetí oddělí nový úkol. Výchozí testy ověř, abys rozeznala starý problém od vlastní změny. Potom uprav validaci a přidej test případu, který opravuješ.

```sh
git diff
git add src/main/java src/test/java
git diff --staged
git commit -m "Odmítnutí kontaktu bez jména"
git push -u origin feature/contact-validation
```

`add` zde připraví změny ve dvou vyjmenovaných adresářích; diff před commitem zkontroluj. `push -u` vytvoří nebo aktualizuje vzdálenou větev a nastaví její sledování. V rozhraní hostingu otevři PR/MR z této větve do `main`.

Popis může být krátký: „Kontakt s prázdným jménem se dříve uložil. Nyní ho konstruktor odmítne před zápisem do seznamu. Ověřeno pro prázdný text, mezery a platné jméno.“ Přidej přesný příkaz k ověření, například `mvn test`. Nespojuj opravu validace s přejmenováním poloviny projektu.

## Co má reviewer zkusit

Reviewer čte zadání a diff, hledá nejasné předpoklady a spouští vhodné testy. Zeptá se například: „Co udělá `null`?“ nebo „Zůstane původní soubor při chybě?“ Autor připomínku buď zapracuje dalším commitem ve stejné větvi, nebo vysvětlí důvod. Připomínky vztahujte ke konkrétnímu kódu a jeho chování.

Pokud se mezitím změnila `main`, načti historii `git fetch origin` a na své pracovní větvi začleň `git merge origin/main`. Vyřeš konflikty, znovu spusť testy a odešli aktualizaci. Směr je zde důležitý: aktualizuješ svou větev hlavní historií. Přijatý PR následně začlení změnu do hlavní větve podle pravidel týmu.

## README jako návod pro spolužačku

**README** je vstupní dokument projektu. Markdown nadpis `#` označí hlavní název, trojité zpětné apostrofy oddělují příkazy. Minimální obsah může být:

```text
# Adresář kontaktů
Požadavky: JDK 21, Maven.
Ověření: mvn test
Spuštění: hlavní třída cz.kurz.Main v IDE.
Příkazy aplikace: pridej, najdi, seznam, uloz, konec.
Data: contacts.json v pracovním adresáři, UTF-8.
Duplicitní jméno nahradí starý kontakt.
Známé omezení: e-mail kontrolujeme jen jako neprázdný text.
```

Každý uvedený příkaz a omezení musí odpovídat skutečné aplikaci. Ověř návod v nové kopii repozitáře, ne jen v IDE, které už má místní nastavení. Připoj malé ukázkové údaje bez soukromých informací a popis testování.

## Konfigurace a tajné údaje

Do repozitáře patří vzor konfigurace, například `config.example.yaml`, ale ne osobní token ani heslo. `.gitignore` může ignorovat místní `.env`; `.env` je běžný název textového souboru s nastavením. Java ho sama automaticky nenačte. Skutečnou proměnnou prostředí přečte `System.getenv("APP_DATA_DIR")`: vrátí text hodnoty nebo `null`, pokud není nastavena. Aplikace musí zvolit výchozí hodnotu a ověřit cestu.

Pokud byl klíč omylem commitnut a sdílen, samotné smazání souboru z nové verze nestačí: zůstává v historii. Klíč zneplatni u poskytovatele a s týmem dohodni další opravu. To není běžný důvod přepisovat historii každé změny.

## Párování a předání práce

Ve dvojici střídej roli píšícího a navigátora. Navigátorka sleduje zadání a může například navrhnout zkoušku s prázdným jménem, zatímco druhá z vás píše kód. Po bloku napište, co funguje, co zbývá a jeden konkrétní další krok. Práci dělte po použitelných scénářích, ne tak, že jeden člověk rozumí pouze testům a druhý pouze aplikaci.
