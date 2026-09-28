# Předání přehledu zásob

## Co projekt dělá
Ze souboru CSV vypíše pouze položky pod minimem a počet kusů k doplnění. Zdrojový soubor nemění. Jde o cvičný model Margeiny komunitní spíže.

## Spuštění z čisté složky
Potřebuješ JDK 21 nebo novější (java i javac) a Maven. Terminál otevři v kořeni projektu vedle pom.xml. První běh může stáhnout závislosti.

```sh
mvn test
java -cp target/classes PantryReport data/pantry.csv
```

Mají projít 3 testy. Druhý příkaz vypíše:

```text
Rice: doplnit 3
Coffee: doplnit 2
```

## Formát dat
UTF-8, bez hlavičky; řádek má name,stock,minimum. Čísla jsou nezáporná celá, jméno neprázdné, u hodnot se ignorují okrajové mezery. Prázdné řádky a řádky začínající # se ignorují. Pole nesmějí obsahovat čárku; nejde o úplný CSV parser s uvozovkami. Při chybě program skončí výjimkou a data nepřepisuje. Při žádném nedostatku vypíše Vseho je dost.

## Co předat
pom.xml, src, data, README.md, HANDOVER.md a .gitignore. Nepředávat target, .idea ani osobní poznámky. Zkopíruj uvedené vstupy do jiné prázdné složky a zopakuj oba příkazy.

## Návrh popisu PR
Přidává přehled chybějících zásob komunitní spíže. Pro Rice,2,5 vypíše doplnit 3; položku na minimu vynechá. Ověření: tři testy, ukázkový vstup a opakované spuštění z nové složky. Omezení: jednoduchý čárkový formát bez uvozovek, při neplatném řádku import končí.
