# Marty si hlídá den návratu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Návrat do budoucnosti**

Doc připravuje další zkušební výpočet návratu a Marty si raději zapisuje datum na papír. Časové okruhy vypadají přesvědčivě, ale malý pomocný program jen přičítá čísla dnů, jako by všechny měsíce měly stejnou délku.

Při přechodu přes konec měsíce vznikne datum, které neexistuje. Marty už zažil dost zvláštních kalendářních překvapení a další nechce řešit za jízdy. Než Doc začne nadšeně plánovat budoucnost, potřebují si být jistí obyčejným datem návratu.

</details>
<!-- aiva-story:end -->

Marty z Návratu do budoucnosti dostal pro testovací jízdu kalendářní plán. Doc napsal počet dnů, ale starý program je přičítá jen k číslu dne v měsíci. Přelom února pak vypadá jako vynález úplně nového kalendáře.

Oprav výpočet data návratu a počtu zbývajících dnů. Vstup tvoří datum odjezdu, dnešní datum v této simulaci a počet dnů cesty, každé na samostatném řádku. Data mají zápis `uuuu-MM-dd`, roky 1900–2100; mohou obsahovat neexistující den. Délka cesty je celé číslo 0–365.

Použij LocalDate.plusDays a ChronoUnit.DAYS.between. Vypiš datum návratu a `Zbyva: N`, pokud návrat nastává dnes nebo později. Jinak vypiš `Zpozdeni: N` s kladným počtem dnů. Při neplatném kterémkoli datu vypiš pouze `Neplatne datum`. Dnešek načítej ze vstupu, nikdy ze systémových hodin.

Pro vstup `2024-02-28`, `2024-02-29`, `2` na třech řádcích vyjde:

```text
Navrat: 2024-03-01
Zbyva: 1
```

Pravidla simulace neřeší časová pásma ani filmové cestování časem. Viz [datum a čas](lesson:dates-and-time).

## Spuštění

JDK 21 nebo novější. Otevři složku v editoru, doplň místa TODO a ulož soubory.
V AIVA spusť kontrolu uloženého kódu. Ručně můžeš ze složky cvičení spustit:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java
java -cp out Main
```
