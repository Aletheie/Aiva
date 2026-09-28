## Vyber strukturu podle otázky

Do playlistu průběžně přidáváš skladby a jednu můžeš chtít přehrát dvakrát. U seznamu již koupených vstupenek naopak nechceš tentýž kód evidovat dvakrát. Pro každou z těchto situací se hodí jiná struktura. Pole má pevnou délku; **Collections Framework** nabízí kolekce pro proměnlivý počet objektů. `List`, `Set` a `Map` jsou rozhraní; `ArrayList`, `HashSet` a `HashMap` konkrétní implementace. `Map` technicky nerozšiřuje rozhraní `Collection`, přesto patří do Collections Frameworku. Zápisu `<String>` už rozumíš z [generik](lesson:generics-overview).

| Potřeba | Typ | Příklad |
|---|---|---|
| Pořadí a pozice, duplicity povoleny | `List<E>` | Playlist skladeb |
| Unikátní hodnoty, bez indexu | `Set<E>` | Množina přihlášených jmen |
| Vyhledání hodnoty podle jedinečného klíče | `Map<K,V>` | Počet bodů podle jména |

## Jeden program, tři pohledy na data

Program patří do `Main.java`. Každý import zpřístupní příslušný typ z `java.util` pod krátkým názvem.

```java
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class Main {
    public static void main(String[] args) {
        List<String> names = new ArrayList<>();
        names.add("Ada");
        names.add("Eva");
        names.add("Ada");
        System.out.println(names.get(1)); // Eva
        System.out.println(names.size()); // 3

        Set<String> unique = new HashSet<>(names);
        System.out.println(unique.size()); // 2
        System.out.println(unique.contains("Ada")); // true

        Map<String, Integer> scores = new HashMap<>();
        scores.put("Ada", 8);
        scores.put("Ada", 10);
        System.out.println(scores.get("Ada")); // 10
        System.out.println(scores.getOrDefault("Iva", 0)); // 0
    }
}
```

`new ArrayList<>()` vytvoří prázdný měnitelný seznam. `add(prvek)` přidá na konec, `get(index)` přečte pozici od nuly a `size()` vrátí počet. Na rozdíl od pole `array.length` je `size` metoda se závorkami. Konstruktor `HashSet<>(names)` převezme prvky seznamu a zachová jen unikátní hodnoty podle `equals` a `hashCode`. `contains(prvek)` zjišťuje přítomnost.

`put(klíč, hodnota)` v mapě vloží dvojici nebo nahradí hodnotu stejného klíče. Proto Ada skončí s deseti body: druhé `put("Ada", 10)` opravilo její původní výsledek 8. Nevytvořilo další řádek pro Adu. `get(klíč)` vrací při neexistujícím klíči `null`. `getOrDefault(klíč, náhradní)` vrátí náhradní hodnotu, když klíč chybí; samotnou mapu tím nezmění. `containsKey(klíč)` odlišuje neexistující klíč od přítomné hodnoty `null`.

## Úpravy a jejich návratové hodnoty

`names.set(0, "Iva")` nahradí prvek na pozici 0. `names.remove(0)` odstraní prvek podle indexu a posune další. `names.remove("Ada")` odstraní první shodnou hodnotu. U `List<Integer>` je proto `remove(1)` odstranění indexu, zatímco `remove(Integer.valueOf(1))` odstraní hodnotu jedna; `Integer.valueOf` vytvoří nebo vrátí obal čísla. `isEmpty()` vrátí, zda je počet nula, `clear()` odstraní všechny prvky.

`unique.add("Ada")` vrátí `false`, pokud už Ada v množině je. `unique.remove("Ada")` vrátí, zda byla odstraněna. `scores.remove("Ada")` vrátí původní hodnotu, nebo `null`, když klíč chyběl. Neměň údaje určující rovnost objektu, dokud je klíčem mapy nebo prvkem hashové množiny; důvod vysvětluje [lekce o rovnosti objektů](lesson:object-contract-overview).

## Procházení a bezpečné mazání

`for (String name : names)` postupně přečte všechny prvky. Přes `scores.keySet()` získáš pohled na klíče, přes `scores.values()` na hodnoty. Dvojice procházíš takto:

```java
for (Map.Entry<String, Integer> entry : scores.entrySet()) {
    System.out.println(entry.getKey() + ": " + entry.getValue());
}
```

`entrySet()` vrací pohled na položky mapy, `Map.Entry` je typ dvojice a `getKey()`/`getValue()` její složky. Pořadí `HashMap` není zaručeno; neporovnávej její výpis jako seřazený seznam.

Pokud chceš při procházení mazat, použij **iterátor**. Nad třídu přidej `import java.util.Iterator;` a do `main`:

```java
Iterator<String> iterator = names.iterator();
while (iterator.hasNext()) {
    String name = iterator.next();
    if (name.equals("Ada")) {
        iterator.remove();
    }
}
```

`iterator()` vytvoří postupný průchod, `hasNext()` ověří další prvek, `next()` ho vrátí a posune průchod. `remove()` odstraní právě vrácený prvek a lze ho volat jednou po `next()`. Přímé `names.remove(...)` uvnitř for-each může vyvolat `ConcurrentModificationException` i v jediném vlákně. Později poznáš kratší `removeIf(predicate)` s [lambdou](lesson:lambdas-overview).

## Rozdíly implementací

`ArrayList` používá měnitelné vnitřní pole: rychlý přístup indexem, přidání na konec obvykle levné, vložení doprostřed posouvá prvky. `LinkedList` má propojené uzly: hledání indexu vyžaduje průchod. Mazání známého uzlu přes iterátor je levné, ale jeho nalezení levné být nemusí. Proto pro běžný seznam začni `ArrayList`, ne automaticky `LinkedList` při každém mazání.

`HashSet` a `HashMap` nezaručují pořadí; `LinkedHashSet` a `LinkedHashMap` zachovávají pořadí vložení. `TreeSet` a `TreeMap` udržují seřazené hodnoty či klíče. „Rychlé hledání“ u hashových struktur obvykle znamená průměrně konstantní čas; není to záruka pro libovolné rozložení hashů.

**Fronta (queue)** odebírá položky v pořadí příchodu, podobně jako čekání na lístky u pokladny. Kdo přišel první, jde první na řadu. Oboustranná `Deque` dovoluje oba konce. S importy `java.util.Deque` a `java.util.ArrayDeque` lze napsat:

```java
Deque<String> queue = new ArrayDeque<>();
queue.offerLast("Ada");
queue.offerLast("Eva");
System.out.println(queue.peekFirst()); // Ada, zůstane ve frontě
System.out.println(queue.pollFirst()); // Ada, odstraní se
```

`offerLast` přidává na konec, `peekFirst` čte začátek, `pollFirst` čte a odebírá. Prázdná fronta u posledních dvou metod vrátí `null`; `ArrayDeque` nulové prvky nepřijímá.

## Řazení a neměnitelné seznamy

`List.of("Eva", "Ada")` vytvoří neměnitelný seznam bez `null`. Pro úpravy ho obal `new ArrayList<>(List.of("Eva", "Ada"))`. `List.copyOf(names)` vytvoří neměnitelnou mělkou kopii: objekty uvnitř stále mohou být měnitelné.

S `import java.util.Comparator;` seřadí `names.sort(Comparator.naturalOrder())` texty přirozeně a `Comparator.reverseOrder()` opačně. Není to automaticky české abecední řazení. `Comparator` je externí pravidlo porovnání; `Comparable<T>` definuje přirozené pořadí uvnitř typu metodou `compareTo(T other)`. Ta vrací záporné číslo pro menší hodnotu, nulu pro shodu pořadí, kladné pro větší. Například `Integer.compare(a, b)` bezpečně porovná dvě čísla bez přetečení, které hrozí při `a - b`.

Před procvičením rozhodni: nákupní seznam je `List`, unikátní štítky `Set`, ceník podle kódu `Map`. Rozhodnutí zdůvodni požadovanými operacemi, ne názvem kolekce.

> [!OPTIONAL] Pod povrch: kapacita, hash a složitost
>
> ArrayList odděluje počet prvků `size` od vnitřní kapacity pole. Při zaplnění může vytvořit větší pole a reference zkopírovat. Jednotlivé přidání tedy někdy stojí více práce, ale dlouhá řada přidávání má amortizovaně konstantní náklad na prvek. „Amortizovaně“ znamená zprůměrování i občasných dražších kroků. Na přesný způsob zvětšování kapacity se nespoléhej; může se mezi implementacemi lišit.
>
> HashMap z hashCode odvozuje umístění, v němž hledá odpovídající equals. Kolize znamená více kandidátů; stejný hash není důkaz rovnosti. Označení O(1) popisuje obvyklou práci nezávislou na počtu prvků za dobrých předpokladů, O(n) průchod úměrný počtu prvků. Nejde o milisekundy ani záruku, že libovolná malá mapa porazí libovolný seznam.
>
> LinkedList přidává odkazy mezi uzly a alokace jednotlivých uzlů. Levné přepojení uzlu neodstraňuje cenu jeho hledání. Proto volbu nedělej podle sloganu „mazání je rychlejší“, ale podle skutečné posloupnosti operací.
