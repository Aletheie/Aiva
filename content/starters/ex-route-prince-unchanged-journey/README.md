# Malému princi se nesmí přepsat cesta

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Malý princ**

Malý princ ukazuje zeměpisci plán cesty mezi planetami. Některé zastávky už schválil a chtěl by si uchovat mapu toho, s čím původně počítal. Zeměpisec však po rozhovoru najde další zajímavé místo a doplní ho do pracovního seznamu.

Nová zastávka se okamžitě objeví i na staré schválené mapě. Malý princ si ji přitom nepamatuje. Potřebuje, aby záznam tehdejšího rozhodnutí zůstal stejný, i když se o budoucí cestě ještě vede dlouhá debata.

</details>
<!-- aiva-story:end -->

Malý princ schválil cestu mezi planetami. Zeměpisec pak do pracovního seznamu přidá další zastávku a kupodivu se změní i dávno schválená mapa. Oprav sdílení dat: schválený plán se při pozdějších úpravách pracovního seznamu nesmí měnit.

V kompaktním konstruktoru záznamu `Journey` ulož neměnitelnou kopii předaného seznamu pomocí `List.copyOf`. Seznam tvoří neměnné texty; kopírování dalších objektů proto není potřeba. Původní draft musí zůstat měnitelný. Neupravuj připravený Main ani nevyráběj starý výpis pomocí mazání posledního prvku.

Vstup: počet zastávek 0–20, potom jejich názvy po řádcích a nakonec jedna nová zastávka. Všechny názvy jsou neprázdné bez čárek. Pro vstup:

```text
2
B-612
Zeme
Mesic
```

má vyjít:

```text
Schvaleno: [B-612, Zeme]
Novy navrh: [B-612, Zeme, Mesic]
```

V editoru navíc ověř, že přes `approved.stops().add("Mars")` nelze měnit schválený seznam: pokus skončí UnsupportedOperationException. Tento pokus pak odstraň, aby výstupní kontrola doběhla. Viz [neměnná data](lesson:immutable-data).

## Spuštění

JDK 21 nebo novější. Otevři složku v editoru, doplň místa TODO a ulož soubory.
V AIVA spusť kontrolu uloženého kódu. Ručně můžeš ze složky cvičení spustit:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java
java -cp out Main
```
