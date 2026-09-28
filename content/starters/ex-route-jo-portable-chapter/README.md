# Jo pošle kapitolu, ne celé své IDE

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Malé ženy · současná variace**

Jo má v současné verzi příběhu malý program na štítky ke kapitolám. Amy chce pomoci s přípravou rukopisu, ale nemá Jo editor ani stejně uspořádané složky. Dostane celý projekt a pochopitelně se ptá, který soubor vlastně otevřít.

Jo by raději poslala použitelný balíček a krátký návod. Amy má zvládnout tisk z obyčejného terminálu, i když si soubor uloží jinam. Když se při spuštění splete, program má vysvětlit postup stejně srozumitelně jako popisek na obálce kapitoly.

</details>
<!-- aiva-story:end -->

Jo March z Malých žen si napsala malý program na tisk štítků kapitol. Amy ho chce spustit z obyčejného terminálu. Připrav balíček, který funguje i mimo složku projektu, a srozumitelný návod při chybném spuštění.

Oprav Main: přijímá právě jeden neprázdný argument s názvem kapitoly, očistí jeho okraje a vypíše `Jo tiskne: ` a název. Při žádném argumentu, více argumentech nebo argumentu ze samých bílých znaků vypíše pouze:

```text
Pouziti: java -jar little-women.jar "Nazev kapitoly"
```

Potom přelož program a vytvoř JAR se vstupní třídou Main podle příkazů v README. Žádné závislosti ani síť nepotřebuje. Zkopíruj samotný JAR do jiné prázdné složky a spusť jej přes java -jar. Název s mezerami předej jako jeden argument v uvozovkách. Nevyžaduj zdrojové soubory ani editor.

Do vlastního krátkého DELIVERY.md zapiš požadavek JDK 21+ a přesný příkaz s ukázkovým názvem. Kontrola je ruční: samotný výpis v editoru nedokazuje přenositelnost archivu. Viz [spouštění a JAR](lesson:shipping-java).

## Spuštění


JDK 21+ obsahuje javac, jar i java. Ve složce cvičení:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java
jar --create --file little-women.jar --main-class Main -C out .
java -jar little-women.jar "Prvni kapitola"
java -jar little-women.jar
java -jar little-women.jar "   "
java -jar little-women.jar prvni druha
```

První příkaz ke spuštění vypíše `Jo tiskne: Prvni kapitola`, další tři návod k použití. Obsah archivu ověř přes `jar --list --file little-women.jar`. Zkopíruj pouze JAR do nové prázdné složky a zopakuj první spuštění; projekt se soubory .java v ní nesmí být potřeba. Hotový JAR nesdílíme automaticky s nikým dalším.


## Ověření

- Přesně jeden platný argument vytvoří správný očištěný štítek.
- Žádný argument, více argumentů i samé mezery vypíší návod bez pádu.
- JAR obsahuje Main.class a manifest se vstupní třídou.
- Samotný JAR funguje v nové prázdné složce.
- DELIVERY.md uvádí JDK 21+ a příkaz s argumentem v uvozovkách.
