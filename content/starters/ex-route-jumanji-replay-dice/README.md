# Jumanji potřebuje opakovatelný hod

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Jumanji**

Na obrazovce běží zkušební desková hra inspirovaná Jumanji. Zvuk bubnů zatím obstarává reproduktor, džungli pár obrázků a kostka po jednom hodu pošle figurku kamsi mimo plán. Testující si poznamená průběh a zavolá kolegyni.

Při druhém spuštění padá všechno jinak. Zmizelá figurka se odmítá znovu ztratit právě ve chvíli, kdy je potřeba chybu prozkoumat. Pro hledání chyby potřebují zopakovat stejné hody ve stejném pořadí.

</details>
<!-- aiva-story:end -->

V testovací verzi hry inspirované Jumanji se po podivném hodu ztratí figurka. Kolegyně chce chybu zopakovat, ale každý běh hází jinak. Připrav kostku, která se stejným seedem zopakuje stejnou sérii. Zdejší pravidla jsou jednoduchá: obyčejná šestistěnná kostka, žádná znalost filmu.

Doplň `roll(Random random)`: z předaného generátoru vrať celé číslo 1 až 6 včetně. Použij `nextInt(6)` a uprav rozsah. Nevytvářej nový generátor při každém hodu. Starter čte celočíselný long seed a počet hodů 0–20, vytváří jeden Random a vypisuje jednotlivé hody i součet.

Pro vstup `42 3` mají vyjít:

```text
Hod: 3
Hod: 4
Hod: 1
Soucet: 8
```

Při nule hodů se vypíše jen `Soucet: 0`. Výsledky nesmí být zapsané napevno. Po opravě spusť stejný vstup dvakrát a porovnej celý výpis; pak změň seed. Viz [náhoda a seed](lesson:random-and-seeds).

## Spuštění

JDK 21 nebo novější. Otevři složku v editoru, doplň místa TODO a ulož soubory.
V AIVA spusť kontrolu uloženého kódu. Ručně můžeš ze složky cvičení spustit:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java
java -cp out Main
```
