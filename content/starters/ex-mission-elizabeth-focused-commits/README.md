# Elizabeth má tři změny, ale jen dva commity

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pýcha a předsudek · současná variace**

Elizabeth opravila překlep v digitálním katalogu a připravila změnu k předání. Potom přidala další knihu a vedle si uložila soukromé poznámky ke čtení. Charlotte má změny zkontrolovat a ocení, když hned pozná, co spolu souvisí.

Elizabeth chce oddělit drobnou opravu od nového obsahu. Osobní komentáře k postavám mají zůstat jen u ní; v Longbournu je dost živých debat i bez jejich zveřejnění. Potřebuje pečlivě vybrat, co do jednotlivých kroků historie opravdu patří.

</details>
<!-- aiva-story:end -->

Elizabeth Bennet opravila překlep v katalogu a pak přidala další knihu. Oprava už čeká ve stagingu, nová položka ještě ne. Ulož opravu a novou knihu do dvou samostatných commitů a soukromé poznámky ponech mimo historii.

## Tvůj úkol

Spusť `bash prepare.sh` (Windows: Git Bash) a přejdi do vytvořeného staging-lab. Skript nepřepíše existující složku. Nejdřív porovnej `git diff --cached`, `git diff` a `git status --short`. V prvním commitu má být jen oprava Prejudce → Prejudice. Druhý commit má přidat Little Women a dokumentaci sloupců v README. notes.private.txt musí zůstat na disku mimo historii. Nedělej nové git add před prvním commitem: oprava už je připravená ve stagingu. Potom přidej výslovně jen soubory pro druhý commit. Ověř obsah obou commitů přes git show a poznámky přes git ls-files.

## Připravené okolí

Lokální historie, staged oprava i další pracovní změny jsou připravené. Nepoužívá se žádný skutečný vzdálený repozitář a není potřeba push.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Ověření dokonči podle konkrétních bodů níže.

## Kontrola

- [ ] První nový commit mění jen překlep a neobsahuje Little Women.
- [ ] Druhý commit obsahuje novou knihu i vysvětlení sloupců.
- [ ] Soukromý soubor stále existuje, ale git ls-files notes.private.txt nic nevypíše.
- [ ] Rozumím, proč může být tentýž soubor současně staged i upravený v pracovní složce.
