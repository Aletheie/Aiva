# Bridget ruší rezervaci přesně na hranici

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Deník Bridget Jones**

Bridget se podařilo naplánovat večer, který se nakonec hodí úplně všem — až na ni. Při změně rezervace zjistí, že rozhodují přesné časové hranice a drobné zaokrouhlení poplatku. O jednu chvíli dřív mohla být situace jiná.

Dosavadní test ověřil jen pohodlný běžný případ. Bridget potřebuje znát chování právě na hranici, kde se pravidlo mění. Příště by ráda dostala překvapení v podobě hezké zprávy, nikoli nečekané částky za zrušení.

</details>
<!-- aiva-story:end -->

Bridget Jones potřebuje vědět, kolik stojí změna plánu. Test běžné rezervace je zelený, ale nic neříká o přesných hranicích ani zaokrouhlení. Pomoz jí předejít nepříjemnému překvapení.

## Tvůj úkol

Doplň `CancellationTest.java`. Vymyšlená pravidla této rezervace: 48 a více celých hodin předem zdarma, 24–47 hodin čtvrtina ceny zaokrouhlená nahoru na celý cent, 0–23 hodin plná cena. Cena je 0–100000 centů; záporné hodiny a cena mimo rozsah vyhodí IllegalArgumentException. Nejprve si napiš tabulku očekávání pro 0, 23, 24, 47, 48 a 49 hodin při ceně 101. Z kořene tohoto samostatného projektu spusť `mvn test` s JDK 21 nebo novějším a Mavenem. Při prvním běhu Maven může stáhnout závislosti. Výsledek a počet testů zkontroluj v `target/surefire-reports`. Přidej zaokrouhlení a neplatné vstupy. Produkční zdroj je správný. Zálohuj ho a postupně vlož každou přiloženou variantu z `variants` do Cancellation.java; testy musí všechny tři odmítnout. Potom vrať původní zdroj.

## Připravené okolí

Tři chybné varianty se liší jen jedním pravidlem. Testuješ veřejnou metodu; nemusíš napodobovat její ify v testu.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Ověření dokonči podle konkrétních bodů níže.

## Kontrola

- [ ] Přesné hranice 24 a 48 i hodnoty těsně před nimi mají samostatná očekávání.
- [ ] 101 centů ve středním pásmu znamená 26, ne 25.
- [ ] Neplatné vstupy jsou odmítnuté i tehdy, kdy by jinak vyšel nulový poplatek.
- [ ] Testy projdou se správným kódem a selžou nad každou ze tří vadných variant.
