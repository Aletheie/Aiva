## Nejprve obyčejné spojování

Pro přehled učení potřebuješ větu se jménem a počtem dokončených lekcí. Zatím ji umíš složit pomocí plus:

```java
String name = "Ada";
int count = 3;
String message = name + ": pocet lekci = " + count;
```

Takový zápis je v pořádku. Když věta obsahuje více hodnot, může být přehlednější **šablona (format string)**:

```java
String message = "%s: pocet lekci = %d".formatted(name, count);
System.out.println(message); // Ada: pocet lekci = 3
```

Obě varianty tvoří stejný text. Vyber jednu; nedeklaruj ve stejném bloku `message` dvakrát.

## Dvě značky pro začátek

`%s` je místo pro text a `%d` pro celé číslo. Šablonu si můžeš představit jako větu se dvěma prázdnými políčky. První hodnota, `name`, vyplní `%s`; druhá, `count`, vyplní `%d`. Pořadí značek a hodnot proto musí souhlasit.

Pokud potřebuješ doslova znak procenta, napiš do šablony `%%`.

Pro krátký pozdrav klidně zůstaň u `+`. Šablona pomáhá hlavně tehdy, když díky ní vidíš celou větu pohromadě.

## Zarovnání a desetinná místa

Tento celý program používá neutrální formát s desetinnou tečkou:

```java
import java.util.Locale;

public class Main {
    public static void main(String[] args) {
        String name = "Ada";
        int lessons = 7;
        double hours = 2.5;
        String row = String.format(Locale.ROOT,
                "%s | lekce %02d | %.2f h", name, lessons, hours);
        System.out.println(row); // Ada | lekce 07 | 2.50 h
        System.out.printf(Locale.ROOT, "Hotovo: %d%%%n", 80); // Hotovo: 80%
    }
}
```

`String.format(locale, šablona, hodnoty)` vrací nový text. `Locale.ROOT` volí neutrální pravidla, aby příklad nezávisel na nastavení počítače. `%02d` vypíše celé číslo alespoň na dvě pozice s doplněním nul. `%.2f` zobrazí dvě desetinná místa; vypíše například 2.50, ale v proměnné `hours` zůstává původní číslo 2.5. `%n` vloží konec řádku vhodný pro systém.

`System.out.printf` formátuje rovnou do konzole, zatímco `String.format` a textová `.formatted(...)` vracejí String. `formatted` bez explicitního locale využívá výchozí prostředí; pro přesný kontrolovaný číselný výstup je vhodná varianta s `Locale.ROOT`.

## Typ značky musí sedět

`%d` očekává celé číslo, `%f` desetinné. Předání textu místo celého čísla vyvolá chybu formátování; automaticky ho neparsuje. Nedostatek argumentů také selže. V příkladech s penězi nezaměňuj hezky zobrazenou hodnotu za přesně provedený finanční výpočet.

Přidej druhou studentku s 12 lekcemi a 3 hodinami. Nejdřív předpověz výstup s nulovým doplněním a dvěma desetinnými místy. Pro obyčejný pozdrav klidně ponech spojování pomocí plus.
