## Souběžnost není automatické zrychlení

Leia potřebuje hlášení ze dvou stanovišť. Nemusí čekat na první odpověď, než odešle druhý dotaz: oba mohou být rozpracované současně. To je **souběžnost (concurrency)**. **Paralelismus (parallelism)** znamená, že se některé příkazy také opravdu vykonávají ve stejný okamžik. Když jedna úloha čeká na síť, jiná může pokračovat; samotné přidání vláken ale nezrychlí každý výpočet.

**Vlákno (thread)** vykonává posloupnost příkazů. **ExecutorService** spravuje spouštění úloh, takže jejich životnost nemusíš organizovat ručně. **Callable<T>** vrací výsledek; při odeslání přes `submit` dostaneš `Future<T>`, přes který můžeš počkat na dokončení a převzít výsledek. Runnable naproti tomu vlastní návratovou hodnotu nemá.

## Odešli úlohy, potom čekej

Celý soubor `Main.java`, vyžadující JDK 21 nebo novější:

```java
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class Main {
    public static void main(String[] args) throws Exception {
        try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
            Future<Integer> first = executor.submit(() -> 12);
            Future<Integer> second = executor.submit(() -> 8);
            System.out.println(first.get() + second.get()); // 20
        }
    }
}
```

Obě úlohy jsou odeslané dřív, než začneme čekat. Metoda `get()` počká na svůj výsledek. Pořadí jejich dokončení není slíbené, ale součet na hlavním vlákně je určitý. `try-with-resources` uzavře executor a při běžném uzavření počká na dokončení jeho úloh. Vrácení čísel 12 a 8 je tak krátká práce, že ji vlákna nezrychlí. Na těchto známých výsledcích si pouze ukážeme, jak úlohy odeslat a na obě počkat.

## Proč společné total++ ztrácí práci

Zvýšení čísla sestává z přečtení, výpočtu a zápisu. Představ si dvě přijatá hlášení a společný počet 5. Obě vlákna přečtou 5, obě si spočítají 6 a obě zapíšou 6. Správný výsledek měl být 7, ale jedno zvýšení se ztratilo. To je **souběhová chyba (race condition)**. Ani volatile z operace ++ neudělá atomickou operaci: pomáhá s viditelností a uspořádáním přístupů, ne s celým složeným krokem.

Pro jednoduchý sdílený čítač existuje AtomicInteger.incrementAndGet. Pro složené pravidlo více hodnot může být potřeba synchronized nebo jiný zámek. Ještě přehlednější je často sdílení odstranit: každá úloha vypočítá svůj výsledek a jediná část programu je spojí. Tento návrh procvičuje mise s hlášeními.

## Co dělat při chybě nebo přerušení úlohy

Future.get může vyvolat ExecutionException, která obaluje chybu uvnitř úlohy. Přerušení čekání hlásí InterruptedException. Pokud přerušení zachytíš a nepředáváš ho dál, obvykle obnov příznak přes Thread.currentThread().interrupt() a ukonči činnost. Spolknutí chyby a vrácení částečného součtu by vytvářelo zdánlivě úspěšný nesprávný výsledek.

Sleep není synchronizace: neříká, že druhé vlákno něco dokončilo. Pro spojení výsledků použij get nebo jiný odpovídající synchronizační prostředek. Skutečné síťové úlohy navíc potřebují vlastní časové limity a domluvené rušení; samotné close není univerzální timeout.

## Co mění virtuální vlákna

Virtuální vlákna spravuje JVM a hodí se pro mnoho úloh čekajících na vstup a výstup. Neodstraňují datové závody ani limity databázových spojení. Pro neomezený vstup proto nevytvářej neomezený počet požadavků na službu jen proto, že vlákna jsou levnější. Počet současných náročných operací musí odpovídat prostředku, který používají.

V testu kontroluj hodnoty a pravidla, nikoli údajné přesné pořadí výpisů jednotlivých vláken. Náš úkol má pevný malý limit vstupu a vypisuje až hotový součet, takže kontrola nezávisí na náhodném plánování.
