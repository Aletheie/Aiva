## Nemusíš všechno psát ručně

V editoru zkus napsat začátek známého názvu, třeba `System.out.pr`. **Doplňování (code completion)** nabídne pokračování. Vyber `println` a doplň vlastní text.

V nabídce editoru najdeš také tyto nástroje. Jejich klávesové zkratky se liší podle editoru a systému.

## Formátování (Format / Reformat Code)

Srovná odsazení a mezery. Pomůže vidět, co patří do které závorky. Nemění ale chybné pravidlo výpočtu na správné.

## Přejmenování (Rename)

Po týdnu se vrátíš ke kódu a z názvu `x` už nepoznáš, že jde o počet lístků. Přes **Rename** ho změň na `ticketCount`. Editor upraví deklaraci i použití této proměnné, takže nemusíš jednotlivé výskyty hledat ručně. Než změny přijmeš, prohlédni si jejich náhled.

## Komentář a rychlá oprava

Příkaz **Toggle Line Comment** přidá nebo odebere `//` u vybraného řádku. **Quick Fix** nabízí opravu konkrétního problému, třeba chybějící import.

Návrh si vždy přečti. Pokud mu nerozumíš, vrať změnu a porovnej kód s ukázkou v lekci. Editor pomáhá s psaním, ale záměr programu určuješ ty.

## Vyzkoušej změnu na malém souboru

Celý program si vlož do `Main.java`:

```java
public class Main {
    static int total(int ticketCount, int ticketPrice) {
        return ticketCount * ticketPrice;
    }

    public static void main(String[] args) {
        int price = total(3, 120);
        System.out.println(price); // 360
    }
}
```

Použij **Rename** na parametru `ticketCount` a změň ho na `count`. Editor má změnit deklaraci i použití v násobení; argument 3 ve volání se nepřejmenovává. Potom použij **Find usages** na `total`: zobrazí místa, která metodu používají. **Go to declaration** tě z volání přenese k její definici.

## Dokumentace u metody

U `System.out.println` otevři rychlou dokumentaci. Zjisti, jaké argumenty umí přijmout a zda vrací hodnotu. U neznámé metody nespoléhej jen na nápovědu názvu: dokumentace určuje i chování při null, prázdných datech nebo chybě.

**Extract method** umí přesunout vybraný výpočet do pojmenované metody a navrhnout parametry. Před potvrzením ověř, že metoda reprezentuje jeden úkol a jméno ho vystihuje. **Optimize imports** odstraní nepoužité importy; nestáhne chybějící Maven závislost.

## Rychlá oprava musí odpovídat záměru

Když metoda očekává int, ale předáš text, IDE může nabídnout změnu typu nebo převod. To jsou různé významové změny. Nejdřív rozhodni, zda je vstup číslo určené k počítání, nebo identifikátor, který má zůstat textem. Editor zná typovou chybu, nikoli celé zadání.

Po přejmenování a formátování program znovu spusť: výstup musí zůstat 360. Upravila jsi uspořádání kódu při zachování chování, čemuž se říká **refaktoring (refactoring)**. Kdybys ale změnila cenu lístku ze 120 na 150, očekávaná částka by už byla jiná: 450.
