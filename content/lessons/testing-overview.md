## Test porovná výsledek s očekáváním

Nela v e-shopu slibuje dopravu zdarma od 1000 Kč. Objednávka za 999 Kč má dopravu za 79 Kč, objednávka přesně za 1000 Kč už za nulu. Tato očekávání můžeme zapsat do programu, který výpočet opakovaně zkontroluje. To je **jednotkový test (unit test)**. **JUnit** takové testy spouští a ukáže, když skutečný výsledek nesouhlasí.

Tady ověřujeme samotný výpočet bez konzole nebo sítě. Spolupráci více částí programu později ověří integrační test.

Navazuješ na [ladění](lesson:debugging-overview) a [Maven](lesson:maven-overview). V `pom.xml` použij ukázaný `junit-jupiter` 5.12.2 s rozsahem `test` a Surefire 3.5.3. Jupiter je část JUnit pro psaní a běh těchto testů. Test není metoda `main`, kterou bys musela volat sama.

## Logika oddělená od výpisu

Do `src/main/java/Shipping.java` vlož:

```java
public class Shipping {
    public int cost(int orderTotal) {
        if (orderTotal < 0) {
            throw new IllegalArgumentException("Záporná objednávka");
        }
        return orderTotal >= 1000 ? 0 : 79;
    }
}
```

Metoda vrací cenu dopravy v celých korunách. Neklade otázky, nečte soubor a nic nevypisuje. Proto ji lze snadno zavolat s mnoha vstupy. `>= 1000` zahrnuje přesnou hranici tisíc korun; `?:` vybírá mezi 0 a 79.

Do `src/test/java/ShippingTest.java` vlož:

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class ShippingTest {
    @Test
    void freeAtThreshold() {
        Shipping shipping = new Shipping(); // Arrange
        int actual = shipping.cost(1000);   // Act
        assertEquals(0, actual);            // Assert
    }

    @Test
    void rejectsNegativeTotal() {
        Shipping shipping = new Shipping();
        assertThrows(IllegalArgumentException.class, () -> shipping.cost(-1));
    }
}
```

`@Test` označí testovací metodu. Název popisuje očekávané chování; test nemá parametry a nic nevrací. `assertEquals(očekávané, skutečné)` ověří rovnost. `import static` dovoluje volat statickou metodu bez předpony `Assertions.`. **Arrange–Act–Assert** odděluje přípravu, provedení a kontrolu. Nemusíš vždy psát komentáře, ale pořadí zachovej.

`assertThrows(Typ.class, akce)` spustí lambdu a ověří vyvolání očekávané výjimky nebo jejího potomka. Předáváme chování `() -> shipping.cost(-1)`, nikoli již spočítanou hodnotu. Metoda zároveň vrací zachycenou výjimku, takže lze zkontrolovat zprávu přes `getMessage()`, pokud zadání vyžaduje konkrétní znění zprávy.

## Spuštění a čtení selhání

V kořeni projektu spusť `mvn test`, nebo v IDE použij spuštění vedle testu. Oba testy mají projít. Změň `>=` na `>`: první test nyní selže s očekávanou nulou a skutečnou hodnotou 79. Vrať správný operátor a ověř zelený výsledek. Chyba překladu testu je jiný problém než selhané očekávání za běhu.

`assertTrue(podmínka)` očekává pravdu, `assertFalse` nepravdu, `assertNull` chybějící objekt a `assertNotNull` přítomný objekt. Pro pole používej `assertArrayEquals`, protože běžná rovnost pole neporovnává jeho prvky. Desetinné výsledky kontroluj s tolerancí, například `assertEquals(0.3, 0.1 + 0.2, 0.000001)`; třetí argument určuje dovolenou odchylku.

## Hranice a parametrizované testy

Pro dopravu jsou podstatné vstupy -1, 0, 999, 1000 a 1001. Jediný běžný vstup by chybu na hranici nezachytil. Když stejný scénář zkouší více dat, přidej do `ShippingTest`:

```java
@org.junit.jupiter.params.ParameterizedTest
@org.junit.jupiter.params.provider.CsvSource({"0,79", "999,79", "1000,0", "1001,0"})
void pricesAtBoundaries(int total, int expected) {
    assertEquals(expected, new Shipping().cost(total));
}
```

`@ParameterizedTest` spouští metodu vícekrát. `@CsvSource` dodává řádky hodnot oddělených čárkou, které JUnit převede na parametry `int total` a `int expected`. Úplná jména anotací zde šetří další importy; chování je stejné jako s importem. Balíček `junit-jupiter` použitý v POM obsahuje i podporu parametrizace.

## Izolace a testovatelný návrh

Každý test musí fungovat samostatně i v jiném pořadí. Sdílené statické počítadlo nebo předpoklad „předchozí test vytvořil soubor“ tuto vlastnost porušuje. `@BeforeEach` označí přípravu spouštěnou před každým testem; hodí se například pro vytvoření nového objektu `Shipping`, který jednotlivé testy potřebují.

Testy souborů mohou přijmout pole `@TempDir Path directory` s importy `org.junit.jupiter.api.io.TempDir` a `java.nio.file.Path`. JUnit vytvoří izolovaný dočasný adresář a spravuje jeho úklid. Cestu předej testovanému kódu místo pevného názvu v dokumentech uživatele.

Testuj veřejný výsledek a pravidla, ne přesný počet lokálních proměnných. Když metoda současně načítá konzoli, počítá a ukládá, rozděl odpovědnosti. Následující [TDD a testovací náhrady](lesson:testing-doubles) ukážou, jak návrh ovlivňují krátké testovací cykly a předané závislosti.

> [!OPTIONAL] Pod povrch: co znamená zelený test
>
> Test porovná pozorovaný výsledek s očekáváním, kterému se říká **testovací orákulum**. Pokud je očekávání chybné, zelený test pouze potvrzuje shodu dvou chyb. Proto výsledky odvozuj ze zadání a ručně spočitatelných případů, ne kopírováním výpočtu implementace do testu.
>
> Pokrytí řádků říká, že daným místem test prošel, nikoli že ověřil všechny hranice nebo kombinace. U `>= 1000` jsou 999 a 1000 informativnější než deset náhodných cen daleko od hranice. Testy také nezaručují absenci všech chyb; ukazují, že pro zvolené vstupy program splnil zapsaná očekávání.
