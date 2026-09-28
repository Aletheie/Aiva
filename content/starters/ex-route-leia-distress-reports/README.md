# Leia posbírá hlášení bez ztracených zpráv

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Star Wars**

Leia přijímá hlášení několika lodí současně. Na velitelském stanovišti přibývají zprávy a každá může obsahovat žádost o pomoc. V připravené cvičné simulaci se jejich naléhavé značky mají sečíst do společného přehledu.

Když zprávy dorazí rychle po sobě, část součtu někdy zmizí. Jednotlivé úlohy si navzájem přepisují rozpracovaný výsledek. Leia potřebuje započítat všechna přijatá volání. Podle výsledku rozhoduje, kam pošle pomoc.

</details>
<!-- aiva-story:end -->

Leia ze Star Wars přijímá hlášení několika lodí. Každý vykřičník v naší jednoduché simulaci znamená jedno volání o pomoc. Dřívější pokus nechal všechny úlohy přičítat do stejného čítače a část výsledků občas zmizela.

Doplň `collect(ExecutorService executor, List<String> messages)`. Pro každou zprávu odešli samostatnou Callable přes submit, která vrátí výsledek připravené distressCalls. Ulož Future<Integer> všech úloh. Teprve potom v jednom vlákně vyčkej na jejich get a sečti výsledky. Žádný sdílený měnitelný čítač, žádné odhadování dokončení přes sleep.

Vstup: počet zpráv 0–20 a stejný počet řádků o 0–120 ASCII znacích. Pro:

```text
3
Falcon!!
All clear
Help!
```

má vyjít `Volani o pomoc: 3`. Prázdné zprávy a žádné zprávy dávají nulu. Vstupní kód, distressCalls a uzavření executorů zachovej.

Automatická kontrola ověřuje součet. V editoru navíc ověř, že opravdu nejprve odešleš všechny úlohy a až potom čekáš; správný výstup sám souběžnost neprokáže. Malé zprávy záměrně neslouží jako benchmark rychlosti. Viz [vlákna a souběžnost](lesson:concurrency-basics).

## Spuštění

JDK 21 nebo novější. Otevři složku v editoru, doplň místa TODO a ulož soubory.
V AIVA spusť kontrolu uloženého kódu. Ručně můžeš ze složky cvičení spustit:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java
java -cp out Main
```
