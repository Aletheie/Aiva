# Wednesday zve i hosta beze jména

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Wednesday**

Wednesday chystá v Nevermore komorní večer strašidelných příběhů. Enid pomohla se seznamem hostů a Věc donesla hotové kartičky. Některé jsou ovšem prázdné — možná nedopatřením, možná jako výsledek velmi úsporné komunikace.

Rozesílací program při první chybějící položce skončí. Wednesday by se prázdného hlediště nebála, ale odmítá, aby o návštěvnosti rozhodovala jediná bezejmenná kartička. Potřebuje pokračovat i tehdy, když se o některém hostu zatím nic neví.

</details>
<!-- aiva-story:end -->

Wednesday ze seriálu Wednesday rozesílá pozvánky na večer strašidelných příběhů. Věc jí přinesla seznam, ale u některých hostů schází jméno. Program kvůli jediné prázdné kartičce shodí celou rozesílku. Pomoz mu zpracovat každou pozvánku.

Doplň `guestName(String raw)`. Pro `null`, prázdný řetězec i samotné bílé znaky vrátí `neznamy host`. Jinak odstraň pouze okrajové bílé znaky pomocí `strip()` a zachovej velikost písmen i mezery uvnitř. Doslovný text `null` je běžné jméno, nikoli chybějící reference.

Starter čte počet hostů 0–30 a poté jeden řádek na hosta. Pouze vyhrazený řádek `@missing` převádí na skutečné `null`; ostatní vstupní kód zachovej. Pro vstup:

```text
3
  Enid  
@missing
null
```

má vyjít:

```text
Pozvanka: Enid
Pozvanka: neznamy host
Pozvanka: null
```

Nulový počet nic nevypíše. Chybějící jméno řeš před voláním jeho metod. Výjimky tu nepotřebuješ. Viz [chybějící hodnoty](lesson:null-and-contracts).

## Spuštění

JDK 21 nebo novější. Otevři složku v editoru, doplň místa TODO a ulož soubory.
V AIVA spusť kontrolu uloženého kódu. Ručně můžeš ze složky cvičení spustit:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java
java -cp out Main
```
