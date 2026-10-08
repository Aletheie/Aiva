## Proč se číslo 200 nevejde do byte

Snímač světla posílá hodnoty od 0 do 255. V dokumentaci stojí, že každá zabírá jeden bajt. Zkusíš tedy napsat `byte light = 200;`, ale Java při překladu ohlásí chybu. Jeden bajt přece umí 256 různých hodnot. Kam se poděla čísla nad 127?

Rozhoduje způsob, jakým bity čteme. Java používá pro `byte` čísla **se znaménkem (signed)**: část kombinací patří záporným hodnotám. Snímač popisuje čísla **bez znaménka (unsigned)**: všechny kombinace používá pro nulu a kladné hodnoty. Obě varianty mají stejně bitů, ale jiný rozsah.

V této lekci si rozsahy odvodíš. Nemusíš se učit zpaměti devatenáctimístné hranice `long`; důležité je rozumět tomu, odkud přicházejí.

## Bit, bajt a počet možností

**Bit** může být 0 nebo 1. **Bajt (byte)** tvoří osm bitů. Zkratka `b` označuje bit, `B` bajt: `32 b = 4 B`.

Každým přidaným bitem se počet možných kombinací zdvojnásobí:

| Počet bitů | Možné zápisy nebo počet kombinací |
|---|---|
| 1 | `0`, `1`: dvě kombinace |
| 2 | `00`, `01`, `10`, `11`: čtyři kombinace |
| 3 | `000` až `111`: osm kombinací |
| 8 | `00000000` až `11111111`: 256 kombinací |

Pro **n bitů** tedy dostaneš **2ⁿ kombinací**. U osmi bitů je to osm dvojek vynásobených za sebou: `2 × 2 × 2 × 2 × 2 × 2 × 2 × 2 = 256`.

Zápis `2^n` v matematickém textu také znamená mocninu. **V Javě ale `^` není mocnění**, nýbrž operátor XOR. Vzorec z výkladu tedy nepřepisuj do programu jako `2 ^ 8`.

## Bez znaménka: začínáme nulou

U nezáporných celých čísel (**unsigned integers**) využijeme všech 2ⁿ kombinací pro souvislou řadu začínající nulou. Rozsah je:

**0 až 2ⁿ − 1, včetně obou hranic.**

Pro osm bitů dostaneme `0 až 255`. Odečítáme jedničku, protože jedna z 256 možností už patří nule. Rozsah `0 až 256` by obsahoval 257 hodnot a do osmi bitů se nevešel.

V dvojkové soustavě mají pozice zprava váhy 1, 2, 4, 8 a dále dvojnásobek předchozí váhy. Jednička znamená, že danou váhu započítáme; nula ji vynechá:

```text
Bity:          1   1   0   0   1   0   0   0
Váhy unsigned: 128 64  32  16  8   4   2   1
Součet:        128 + 64 + 8 = 200
```

Tak může snímač uložit hodnotu 200 do jediného bajtu. U všech jedniček je součet `128 + 64 + 32 + 16 + 8 + 4 + 2 + 1 = 255`.

## Se znaménkem: dvojkový doplněk

Typy `byte`, `short`, `int` a `long` používají **dvojkový doplněk (two's complement)**. Nejlevější bit má zápornou váhu. U osmi bitů je to **−128**, ostatní váhy zůstávají 64, 32, 16, 8, 4, 2 a 1.

Není to oddělené minus přilepené k běžnému zápisu kladného čísla. Všech osm bitů společně určuje hodnotu:

| Osm bitů | Čtení bez znaménka | Čtení jako Java `byte` |
|---|---:|---:|
| `00000000` | 0 | 0 |
| `00000001` | 1 | 1 |
| `01111111` | 127 | 127 |
| `10000000` | 128 | −128 |
| `11001000` | 200 | −56 |
| `11111111` | 255 | −1 |

U `11001000` se při čtení se znaménkem sečte `−128 + 64 + 8 = −56`. U `11111111` vyjde `−128 + 127 = −1`. Bity se nezměnily; změnil se jejich číselný význam.

Polovina kombinací začíná nulou, polovina jedničkou. U osmi bitů máme 128 záporných hodnot (`−128` až `−1`) a 128 nezáporných hodnot (`0` až `127`). Nula patří do druhé poloviny, proto maximum není `128` a rozsah není symetrický kolem nuly. Existuje jen jedna nula.

Pro **n bitů ve dvojkovém doplňku** platí rozsah:

**−2ⁿ⁻¹ až 2ⁿ⁻¹ − 1**, tedy přehledněji **−(2^(n − 1)) až 2^(n − 1) − 1**.

Pro `byte` dosadíme `n = 8`: minimum `−2⁷ = −128`, maximum `2⁷ − 1 = 127`. Celkem jde stále o 256 hodnot, ne o poloviční množství.

## Kolik bajtů mají číselné typy Javy

Tabulka uvádí bitovou šířku **samotné hodnoty** a odpovídající počet bajtů. Tyto šířky se nemění podle toho, zda Java běží na 32bitovém nebo 64bitovém počítači.

| Typ | Bity | Bajty hodnoty | Reprezentace a rozsah |
|---|---:|---:|---|
| `byte` | 8 | 1 | Signed: −128 až 127 |
| `short` | 16 | 2 | Signed: −32 768 až 32 767 |
| `int` | 32 | 4 | Signed: −2 147 483 648 až 2 147 483 647 |
| `long` | 64 | 8 | Signed: −9 223 372 036 854 775 808 až 9 223 372 036 854 775 807 |
| `char` | 16 | 2 | Unsigned: 0 až 65 535; kódová jednotka UTF-16 |
| `float` | 32 | 4 | IEEE 754; největší konečná velikost přibližně 3,4 × 10³⁸ |
| `double` | 64 | 8 | IEEE 754; největší konečná velikost přibližně 1,8 × 10³⁰⁸ |

Například u `short` je `n = 16`, takže `2¹⁵ = 32 768`; minimum je −32 768 a maximum o jedničku menší než 32 768. U `int` stejně dosadíme 32 bitů. Rozsahy celých typů potvrzuje [specifikace jazyka Java](https://docs.oracle.com/javase/specs/jls/se21/html/jls-4.html#jls-4.2.1).

**`char` je výjimka bez znaménka**, určená pro kódové jednotky textu UTF-16. Není to obecná náhrada za chybějící `unsigned short`. Výpis `char` zobrazuje znak, ne běžně číselný kód. Pro počty zvol zpravidla `int` nebo `long`; pro text `String`. Jeden viditelný znak může potřebovat více jednotek `char`.

`float` a `double` uchovávají čísla **s plovoucí řádovou čárkou (floating point)**. Bity dělí mezi znaménko, exponent a část určující platné číslice. Umějí kladné i záporné hodnoty a také nekonečna a `NaN`, ale vzorec pro rozsah celých čísel na ně **neplatí**. Větší rozsah také neznamená přesné uložení každého čísla: například všechna celá čísla nad 2²⁴ už `float` po jedničkách nerozliší. Podrobnosti probírá lekce [o desetinných číslech](lesson:numbers-and-money); šířky a meze uvádějí také dokumentace [Float](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/lang/Float.html) a [Double](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/lang/Double.html).

**`boolean` není číselný typ.** Má hodnoty `true` a `false`, ale jazyk neurčuje jednotnou velikost každé takové proměnné v paměti. Dvě možné hodnoty neznamenají, že proměnná nutně zabere právě jeden bit. [Specifikace JVM](https://docs.oracle.com/javase/specs/jvms/se21/html/jvms-2.html#jvms-2.3.4) například rozlišuje logické hodnoty od konkrétního způsobu jejich uložení.

### Čtyři bajty hodnoty nejsou velikost celého objektu

Když má `int` šířku čtyři bajty, neznamená to, že každá věc obsahující jeden `int` zabere v paměti právě čtyři bajty. Objekt `Integer`, pole i vlastní objekt mohou potřebovat další prostor pro správu JVM a zarovnání. Umístění lokálních proměnných navíc může optimalizovat překladač JVM. Z tabulky tedy nelze spočítat celou spotřebu aplikace.

Změna `int count = 1;` na `int count = 1000000;` nezmění bitovou šířku typu. Naopak délka textového zápisu do souboru se změnit může: znak `1` a sedm znaků `1000000` jsou jiná otázka než reprezentace hodnoty `int`.

## Hranice si nech vypsat

Pomocné třídy nabízejí pojmenované konstanty. `Integer` poskytuje informace pro primitivní `int`; neznamená to, že níže vytváříme objekt `Integer`.

Celý program můžeš uložit do `Main.java`:

```java
public class Main {
    public static void main(String[] args) {
        System.out.println(Byte.SIZE);         // 8 bitů
        System.out.println(Byte.BYTES);        // 1 bajt
        System.out.println(Short.MIN_VALUE);   // -32768
        System.out.println(Short.MAX_VALUE);   // 32767
        System.out.println(Integer.BYTES);     // 4 bajty
        System.out.println(Long.BYTES);        // 8 bajtů

        int last = Integer.MAX_VALUE;
        System.out.println(last);             // 2147483647
        System.out.println(last + 1);         // -2147483648
    }
}
```

`SIZE` udává bity, `BYTES` bajty a `MIN_VALUE`/`MAX_VALUE` meze daného celočíselného typu. Poslední součet ukazuje **přetečení (overflow)**: pro větší kladný výsledek už v `int` není místo a obyčejné sčítání nevyhodí výjimku. Zápis `byte light = 200;` se naopak odmítne už při překladu, protože známá konstanta přesahuje rozsah `byte`.

Pozor na podobný název u desetinných typů: `Float.MIN_VALUE` a `Double.MIN_VALUE` znamenají **nejmenší kladnou nenulovou hodnotu**, nikoli nejzápornější číslo. Jejich záporné konečné meze získáš jako `-Float.MAX_VALUE` a `-Double.MAX_VALUE`.

## Jak číst unsigned data v Javě

Java nemá deklarace `unsigned byte`, `unsigned int` ani `unsigned long`. Když chceš v aplikaci pohodlně počítat s hodnotou 200, můžeš napsat prostě `int light = 200;`. Čtyřbajtový `int` takovou hodnotu pojme.

Jiná situace nastane, když už **máš bajt ze souboru nebo zařízení**, jehož dokumentace určuje nezáporné hodnoty. Pomocná metoda umí stejné bity přečíst bez znaménka a vrátit výsledek ve větším typu:

```java
byte raw = -56;                       // Bity 11001000, jako u snímače
int light = Byte.toUnsignedInt(raw);
System.out.println(raw);              // -56
System.out.println(light);            // 200
```

`Byte.toUnsignedInt` přijme jeden `byte` a vrátí `int` od 0 do 255. Pro záporný `byte` tím dostaneš jeho hodnotu plus 256; nezáporné hodnoty se nezmění. Původní `raw` zůstává −56. Zápornou teplotu takto nepřeváděj: interpretace unsigned je správná jen tehdy, pokud tak data skutečně popisuje zdroj. Stejný postup pro 16 bitů nabízí `Short.toUnsignedInt`. Viz dokumentace [Byte](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/lang/Byte.html#toUnsignedInt(byte)) a [Short](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/lang/Short.html#toUnsignedInt(short)).

> [!OPTIONAL] Unsigned hodnoty v int a long
>
> Pro běžný počet nad maximem `int` bývá nejčitelnější `long`. Při čtení cizího binárního formátu ale můžeš potřebovat přesně 32 nebo 64 bitů bez znaménka.
>
> ```java
> int bits = Integer.parseUnsignedInt("4294967295");
> System.out.println(bits);                         // -1
> System.out.println(Integer.toUnsignedLong(bits)); // 4294967295
> System.out.println(Integer.toUnsignedString(bits)); // 4294967295
>
> long moreBits = Long.parseUnsignedLong("18446744073709551615");
> System.out.println(moreBits);                       // -1
> System.out.println(Long.toUnsignedString(moreBits)); // 18446744073709551615
> ```
>
> První text představuje `2³² − 1`, druhý `2⁶⁴ − 1`. Metody `parseUnsignedInt` a `parseUnsignedLong` načtou unsigned zápis, ale **vracejí běžné signed typy**. U všech jedniček tedy obyčejný výpis zobrazí −1. Unsigned význam zachovávají příslušné pomocné metody; nevzniká nový datový typ. `Integer.toUnsignedLong` se vejde do signed `long`, ale pro unsigned 64bitové maximum už žádný větší primitivní celočíselný typ není.
>
> Pro porovnání a dělení používej `Integer.compareUnsigned`, `Integer.divideUnsigned` a `Integer.remainderUnsigned`, případně stejnojmenné metody třídy `Long`. Například `Integer.compareUnsigned(-1, 1)` vrátí kladné číslo: 4 294 967 295 je při unsigned čtení větší než 1. Běžné `-1 > 1` vrací `false`, protože operátor čte oba operandy se znaménkem. `compareUnsigned` vrací záporné číslo, nulu nebo kladné číslo pro menší, stejnou nebo větší hodnotu; nevrací `boolean`.
>
> Přesné chování a další příklady najdeš v dokumentaci [Integer](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/lang/Integer.html#toUnsignedLong(int)) a [Long](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/lang/Long.html#parseUnsignedLong(java.lang.String)). Pro běžné počítání si zatím vystačíš se signed `int` a `long`.

Při volbě typu si vždy polož dvě otázky: **jaké hodnoty potřebuji** a **jak zdroj dat interpretuje jejich bity**. Rozsah se odvíjí od obou odpovědí, samotný počet bajtů nestačí.
