## TDD: nejdřív napiš test

Doprava zatím stojí vždy 79 Kč a teď přidáváš pravidlo „od tisíce zdarma“. Nejdřív napíšeš test, který za objednávku 1000 Kč očekává nulu. Test selže, protože pravidlo ještě chybí. Doplníš podmínku, test projde a potom můžeš zpřehlednit kód. Tento postup se nazývá **Test Driven Development (TDD)** a opakuje kroky **red, green, refactor**: selhání, splnění očekávání a úpravu struktury.

Na [dopravě z JUnit lekce](lesson:testing-overview) si napiš test pro hranici 1000 před samotnou podmínkou. „Red“ není náhodná chyba importu: test má odhalovat chybějící pravidlo. Po zprovoznění přidej 999 a záporný vstup. **Refaktoring** mění vnitřní uspořádání bez změny pozorovatelného chování, například pojmenuje cenu dopravy konstantou.

## Testovací náhrada závislosti

U pozdravu chceš ověřit, že se ze jména Ada stane „Ahoj, Ada“. Kvůli tomu nemusíš spouštět skutečnou databázi jmen. **Stub** dodá předem připravenou odpověď. **Fake** už může obsahovat jednoduchý funkční katalog v paměti. **Mock** navíc umožní ověřit, na které ID se služba ptala. Tyto náhrady oddělí test pozdravu od vyhledávání jména.

Následující celý program `Main.java` nejprve funguje bez knihovny pro mocky:

```java
interface NameRepository {
    String findName(int id);
}

class GreetingService {
    private final NameRepository repository;

    GreetingService(NameRepository repository) {
        this.repository = repository;
    }

    String greet(int id) {
        String name = repository.findName(id);
        return name == null ? "Ahoj, hoste" : "Ahoj, " + name;
    }
}

public class Main {
    public static void main(String[] args) {
        NameRepository stub = id -> "Ada";
        GreetingService service = new GreetingService(stub);
        System.out.println(service.greet(7)); // Ahoj, Ada
    }
}
```

Metoda `findName(int id)` hledá jméno podle ID; v tomto příkladu znamená `null` nenalezený záznam. Lambda tvoří stub, protože rozhraní má jedinou abstraktní metodu a vrací připravené jméno pro libovolné ID. `GreetingService` dostává závislost konstruktorem: to je [předání závislosti](lesson:interfaces-overview). Test může vložit jiný stub bez změny služby.

## Mockito na stejném příkladu

Do závislostí Mavenu přidej knihovnu **Mockito** pouze pro testy:

```xml
<dependency>
  <groupId>org.mockito</groupId>
  <artifactId>mockito-core</artifactId>
  <version>5.17.0</version>
  <scope>test</scope>
</dependency>
```

Soubor `src/test/java/GreetingServiceTest.java`:

```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class GreetingServiceTest {
    @Test
    void greetsKnownUser() {
        NameRepository repository = mock(NameRepository.class);
        when(repository.findName(7)).thenReturn("Ada");
        GreetingService service = new GreetingService(repository);

        String actual = service.greet(7);

        assertEquals("Ahoj, Ada", actual);
        verify(repository).findName(7);
    }
}
```

`mock(Typ.class)` vytvoří testovací implementaci rozhraní. `when(volání).thenReturn(hodnota)` nastaví odpověď pro konkrétní volání. `verify(repository).findName(7)` ověří, že během provedení přišlo právě jedno takové volání. `assertEquals` dál kontroluje skutečný výsledek služby. Mockito nenahrazuje JUnit, doplňuje ho.

Pro tento příklad používáme pouze náhrady rozhraní. V přiloženém starteru je proto soubor `src/test/resources/mockito-extensions/org.mockito.plugins.MockMaker` s obsahem `mock-maker-proxy`. Vybírá vytváření náhrad bez připojování agenta k běžící JVM. Tato varianta nahrazuje pouze rozhraní, nepoužívá generování potomků tříd ani statické metody; náš návrh další možnosti nepotřebuje. Bez tohoto nastavení používá Mockito 5 standardně jiný mechanismus, který na novějších JDK potřebuje odpovídající konfiguraci agenta.

## Co ověřovat a co ponechat implementaci

Přidej test s `when(repository.findName(99)).thenReturn(null)` a očekávej `Ahoj, hoste`. Potom zkus službu, která omylem hledá ID 7 pro všechny uživatele: test s ID 99 to odhalí. Neověřuj pořadí každého interního kroku, pokud není součástí požadavku; takový test by bránil bezpečnému refaktoringu.

Malý unit test nepotvrdí, že skutečný databázový dotaz nebo JSON soubor funguje. Pro tuto hranici přidej samostatný integrační test se skutečným úložištěm a izolovanými daty. Když stub vždy vrátí Adu, ověříš sestavení pozdravu. Nezjistíš tím ale, jestli skutečná databáze umí Adu pod správným ID najít.
