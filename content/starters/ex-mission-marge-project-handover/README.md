# Marge předává přehled zásob další směně

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Simpsonovi**

Marge připravila přehled zásob pro komunitní spíž a má radost, že se v něm konečně vyzná. Příští službu ale převezme další dobrovolnice. Na zprávu „spusť to jako já“ pochopitelně odpoví, že neví jak.

Lisa navrhne vyzkoušet předání v úplně nové složce. Ukáže se, které cesty, příkazy a ukázkové údaje potřebují skutečné vysvětlení. Marge chce, aby se příští směna věnovala vydávání zásob, nikoli hledání jejího notebooku.

</details>
<!-- aiva-story:end -->

Marge má funkční přehled zásob, ale další dobrovolnice dostala jen zprávu „spusť to jako já“. Pomoz předat projekt tak, aby ho dokázala ověřit bez domlouvání cest a nastavení.

## Tvůj úkol

Kód ponech. Doplň `HANDOVER.md`: účel, JDK a Maven, přesnou složku a příkazy pro testy a ukázkový běh, očekávaný výstup, formát dat a jeho omezení, seznam souborů k předání a krátký popis PR. Z kořene tohoto samostatného projektu spusť `mvn test` s JDK 21 nebo novějším a Mavenem. Při prvním běhu Maven může stáhnout závislosti. Výsledek a počet testů zkontroluj v `target/surefire-reports`. Ukázkový běh je `java -cp target/classes PantryReport data/pantry.csv`. Potom zkopíruj jen soubory potřebné pro předání do jiné prázdné složky a zopakuj obě kontroly. Do dokumentace přidej skutečný výsledek tohoto pokusu. Nikam nic neposílej; popis PR je zde cvičný text.

## Připravené okolí

Výpočet, testy a bezpečná ukázková data jsou hotové. Pro tuto úlohu nepotřebuješ účet na GitHubu ani skutečné spolupracovnici posílat zprávu.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Ověření dokonči podle konkrétních bodů níže.

## Kontrola

- [ ] Nová složka nepotřebuje původní target ani nastavení IDEA.
- [ ] Proběhly 3 testy a ukázka vypisuje Rice: doplnit 3 a Coffee: doplnit 2.
- [ ] Dokumentace vysvětluje CSV bez hlavičky, komentáře, nezáporné hodnoty a omezení čárek.
- [ ] Předání obsahuje ukázková data a neobsahuje vygenerované výstupy.
- [ ] Popis PR říká, co změna dělá, jak byla ověřena a jaké má konkrétní omezení.
