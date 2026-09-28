## Využij hotovou metodu

Ze dvou výsledků závodu chceš vybrat vyšší počet bodů, z dvojice cen tu levnější. Porovnání nemusíš pokaždé psát znovu: Java pro ně má hotové metody.

```java
System.out.println(Math.max(4, 9)); // 9
System.out.println(Math.min(4, 9)); // 4
System.out.println(Math.abs(-7));   // 7
```

`max` vrátí větší hodnotu, `min` menší. `abs` počítá **absolutní hodnotu (absolute value)**, tedy vzdálenost čísla od nuly.

## Méně větvení

Pro větší ze dvou čísel už znáš vlastní metodu s `if`. V běžném programu můžeš napsat:

```java
int highest = Math.max(first, second);
```

`Math` je součást Javy a nepotřebuješ pro něj přidávat `import` ani vytvářet objekt.

## Kdy raději procvičit vlastní postup

Pokud úloha žádá napsat vlastní porovnání, hotová metoda by obešla její smysl. Mimo takové cvičení ji klidně použij.

I hotové metody mají hranice číselných typů: kladný protějšek nejmenšího `int` se do `int` nevejde, takže pro něj `Math.abs` nedá kladný výsledek. Na malých číslech z ukázky tento problém není.

## Další metody a jejich výsledky

Celý `Main.java` kombinuje měření a omezení rozsahu:

```java
public class Main {
    public static void main(String[] args) {
        int requestedVolume = 120;
        int volume = Math.max(0, Math.min(100, requestedVolume));
        double distance = Math.sqrt(3 * 3 + 4 * 4);
        long rounded = Math.round(2.6);
        System.out.println(volume);   // 100
        System.out.println(distance); // 5.0
        System.out.println(rounded);  // 3
        System.out.println(Math.floor(-2.3)); // -3.0
        System.out.println(Math.ceil(-2.3));  // -2.0
        System.out.println(Math.pow(2, 3));   // 8.0
    }
}
```

Přehrávač dovoluje hlasitost od 0 do 100. Požadavek 120 proto nejprve `Math.min(100, 120)` zmenší na 100. Vnější `Math.max(0, 100)` už výsledek ponechá. U požadavku -5 naopak první krok ponechá -5 a druhý ho zvedne na 0. Hodnota 70 projde oběma kroky beze změny. `sqrt` vrací odmocninu jako double; pro záporný argument vrací NaN, nikoli skutečnou odmocninu. `pow(základ, exponent)` počítá mocninu jako double. Pro malé přesné celočíselné mocniny je často jednodušší přímé násobení.

`round(double)` vrací long zaokrouhlený k nejbližšímu celému číslu, při přesné půlce směrem ke kladnému nekonečnu; `Math.round(-2.5)` tedy dává -2. `floor` jde dolů a `ceil` nahoru, oba vracejí double. Ani jedno není totéž co `(int)`, který odřízne směrem k nule.

## Kontrolované celočíselné operace

`Math.addExact`, `subtractExact` a `multiplyExact` vracejí součet, rozdíl nebo součin, ale při přetečení celého typu vyvolají `ArithmeticException`. `Math.toIntExact(longValue)` odmítne hodnotu mimo rozsah int místo jejího tichého zúžení. Například `Math.toIntExact(3_000_000_000L)` selže.

Při čtení cizího výpočtu zjisti nejen název metody, ale i typ argumentů a výsledku. `Math.max` má více přetížených variant; dvě celá čísla nevyžadují vytvoření double. Výsledek kontroluj na ručně spočitatelných hodnotách včetně záporného a hraničního vstupu.
