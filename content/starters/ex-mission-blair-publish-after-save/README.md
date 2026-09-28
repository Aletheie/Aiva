# Blair oznámila článek, který se neuložil

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Gossip Girl**

Blair spustí zveřejnění nového článku a čtenářům odejde oznámení. Dan vzápětí otevře odkaz a najde prázdno: uložení textu selhalo. Serena už mezitím dostala první dotaz, zda šlo o nějakou tajemnou upoutávku.

O žádný záměr nešlo. Blair potřebuje sladit uložení článku s jeho oznámením a ověřit i neúspěšný pokus. Během zkoušení mají zprávy zůstat ve zkušebním doručování, jinak bude redakce vysvětlovat každou opravu celému seznamu čtenářů.

</details>
<!-- aiva-story:end -->

Blair poslala oznámení o novém článku, ale úložiště mezitím odmítlo zápis. Pomoz opravit pořadí a zachytit chybu testem, aniž by se skutečně poslal jediný e-mail.

## Tvůj úkol

Nejprve napiš testy v PublishingServiceTest: úspěch, IOException při save a prázdný nadpis. Ověř, že nad chybným starterem selžou kvůli pravidlům. Pak oprav označený publish: trim nadpisu, prázdný odmítnout před voláním závislostí, jednou save, teprve po úspěchu jednou send se skutečným ID a stejným nadpisem. Vrať ID. IOException má projít volajícímu; žádné oznámení při ní neposílej. Z kořene tohoto samostatného projektu spusť `mvn test` s JDK 21 nebo novějším a Mavenem. Při prvním běhu Maven může stáhnout závislosti. Výsledek a počet testů zkontroluj v `target/surefire-reports`. Pořadí si zaznamenej do společného List<String> v jednoduchých náhradách rozhraní. Připravená Announcement v této úloze nevyhazuje chyby.

## Připravené okolí

Konstruktor a rozhraní ponech. Lambda náhrady vystačí s JUnit; žádný server ani účet nepotřebuješ. Soubory upravuj jen v označených částech.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Ověření dokonči podle konkrétních bodů níže.

## Kontrola

- [ ] Testy nejprve odhalily chybný starter, poté prošly nad opravou.
- [ ] Úspěch ověřuje save před send, skutečné ID a normalizovaný nadpis.
- [ ] Při chybě save neproběhne send a původní IOException není spolknutá.
- [ ] Prázdný nadpis nezavolá ani jednu závislost; test nepoužívá síť.
