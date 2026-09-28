# Zkouškové pod kontrolou (StudyDesk)

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Lea má před zkouškovým povinnosti na papíru, v telefonu i v rozepsané zprávě sobě samé. Jeden úkol už dokončila dvakrát, protože pokaždé našla jiný seznam. Ema navrhne udělat z těchto poznámek malou společnou aplikaci.

StudyDesk má uchovat hotovou práci, ukázat další kroky a přežít změnu plánu i vypnutí počítače. Připravený základ už existuje. Lea do něj potřebuje přidat dokončování, přejmenování a filtrování úkolů. Chce také ověřit, že se změny zachovají po vypnutí programu.

</details>
<!-- aiva-story:end -->

Lea má před zkouškovým úkoly v pěti poznámkách a v hlavě další tři. Pomoz jí dokončit StudyDesk: seznam, který si pamatuje hotovou práci, ukáže jen to, co zbývá, a zvládne i změnu plánu. V připravené aplikaci doplníš změny úkolů, filtrování a testy.

Zadání a kontrolní body najdeš v `PROJECT.md`.

## Spuštění

JDK 21+ a Maven 3.9+. První build stahuje Gson, JUnit a Maven pluginy z Maven Central.

```sh
mvn test
mvn package
java -jar target/studydesk-0.1.0.jar
```

Příkazy: `add NÁZEV`, `list`, `quit`. Data jsou v `data/tasks.json` vzhledem k pracovní složce.
`src/main/java` obsahuje doménu, service, repository a CLI; `src/test/java` obsahuje JUnit testy.
V `PROJECT.md` je zadání rozšíření. AIVA tento Maven projekt neověřuje svým jednoduchým javac runnerem.

## Omezení starteru

Pouze jeden zapisující proces. Nahrazení dočasným souborem není záruka fsync/crash durability;
fallback bez ATOMIC_MOVE nemá záruku atomicity. JSON parser je výchozí Gson parser,
ne striktní validátor neznámých polí či duplicitních klíčů. Zpřísnění validace je vhodné rozšíření.
Místní data nezahrnuj do Gitu. Soubory s důležitými úkoly zálohuj.

## Licence

Zdroj aplikace: MIT. Gson: Apache-2.0. JUnit: EPL-2.0 (pouze testovací závislost).
Při distribuci výsledného JAR zachovej licence a oznámení přibalených závislostí.
