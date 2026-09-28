## Spoj známé části do jednoho programu

Ze seznamu výsledků chceme vybrat lidi s alespoň deseti body a vypsat jejich jména v pořadí. Na jednom příkladu si tak zopakuješ objekty, kontrolu vstupu, kolekce, streamy a testy. Jde o dobrovolné opakování včetně rozšíření kurzu. Pokud jsi streamy nebo některý datový formát přeskočila, můžeš se nejprve vrátit k jeho lekci.

| Blok | Konkrétní výstup |
|---|---|
| Syntaxe a běhové prostředí | Vysvětlíš cestu od `.java` přes překladač k JVM a napíšeš konzolový program s metodami, podmínkami a cyklem. |
| OOP a návrh | Vytvoříš model s konstruktorem, zapouzdřením, rozlišíš statické členy a použiješ rozhraní nebo smysluplnou dědičnost. |
| Data a odolnost | Zvolíš pole, List, Set či Map, zpracuješ data lambdou i streamem a načteš soubor s ošetřením chyby. Rozumíš JSON, XML i YAML. |
| Kvalita a tým | Odladíš chybu, napíšeš JUnit testy, vysvětlíš TDD a Mockito, sestavíš Maven/Gradle projekt a bezpečně spojíš Git větve. |

## Kdo dosáhl deseti bodů

Celý `Main.java` spojuje několik známých prvků bez dalších knihoven:

```java
import java.util.List;

public class Main {
    record Result(String name, int points) {
        Result {
            if (name == null || name.isBlank() || points < 0) {
                throw new IllegalArgumentException("Neplatný výsledek");
            }
        }
    }

    static List<String> successful(List<Result> results) {
        return results.stream()
                .filter(result -> result.points() >= 10)
                .map(Result::name)
                .sorted()
                .toList();
    }

    public static void main(String[] args) {
        List<Result> results = List.of(
                new Result("Eva", 12),
                new Result("Ada", 10),
                new Result("Iva", 9));
        System.out.println(successful(results)); // [Ada, Eva]
    }
}
```

`Result` drží jedno jméno a počet bodů, konstruktor chrání nezápornost a neprázdný název. `successful` je statická metoda bez sdíleného měnitelného stavu: vše potřebné dostává jako parametr. `filter` ponechá body od deseti včetně, `map(Result::name)` vezme jména, `sorted` je seřadí a `toList` vytvoří neměnitelný výsledek. Žádná operace nemaže ze vstupního seznamu.

Vysvětli rozdíl mezi typem `List<Result>` a `List<String>`. Předpověz výsledek pro prázdný seznam a pro dvě položky téhož jména. Prázdný seznam zůstane prázdný; duplicity se zachovají, protože jsme nepoužili `distinct()`.

## Čtyři praktické kontroly

1. **Základy:** přepiš `successful` na cyklus s `ArrayList`, bez streamu. Výsledky musí souhlasit včetně řazení. Ke každé použité metodě řekni vstupy a návratový typ.
2. **OOP:** nakresli UML pro `Result` a vysvětli, proč nemá setter. Navrhni rozhraní pro načtení výsledků, aby výpočet neznal konzoli ani soubor.
3. **Data:** ulož a načti výsledky jako JSON, chybějící a poškozený soubor řeš odděleně. Stejný jeden záznam zapiš jako XML a YAML a pojmenuj jeho části.
4. **Kvalita:** otestuj body 9, 10 a 11, prázdný seznam a neplatný konstruktor. Proveď změnu v Git větvi a nech ji zkontrolovat druhým člověkem.

Pokud některý krok vyžaduje hádání, vrať se ke konkrétní lekci: [metody](lesson:parameters-and-return), [modelování](lesson:oop-design), [kolekce](lesson:collections-overview), [streamy](lesson:streams-overview), [JUnit](lesson:testing-overview) nebo [Git](lesson:git-overview).

## Vyzkoušej vlastní rozšíření

Změň hranici úspěchu z deseti na patnáct bodů. Nejprve si zapiš nové očekávání, pak uprav výpočet a testy. Přidej možnost načíst výsledky ze souboru a zkus, co se stane s chybějícím jménem nebo zápornými body.

Pokud pracujete ve dvojici, jedna připraví změnu a druhá ji zkontroluje podle zadání. Potom si role vyměňte. Do README přidejte přesný příkaz ke spuštění, příklad vstupu a popis chyb, které aplikace umí vysvětlit. Návod ověřte v nové kopii projektu.

Nemusíš znát všechny knihovní metody zpaměti. Měla bys ale umět říct, jakou operaci hledáš, předpovědět výsledek na malém příkladu a zjistit, jestli načtená data splňují pravidla programu.
