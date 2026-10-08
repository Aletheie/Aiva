## Čtyři typy pro začátek

V přihlášce na výlet jsou různé údaje: počet lidí, vzdálenost, jméno a potvrzení účasti. S počtem chceš počítat, jméno vypsat a potvrzení použít při rozhodování. Proto pro ně zvolíme různé typy:

```java
int count = 3;
double distance = 2.5;
String name = "Ada";
boolean ready = true;
```

- `int`: celé číslo, třeba počet.
- `double`: číslo s desetinnou částí. V kódu píšeme tečku.
- `String`: text ve dvojitých uvozovkách. Název začíná velkým S.
- `boolean`: pravda `true`, nebo nepravda `false`. Bez uvozovek.

**Datový typ (data type)** určuje, jaké hodnoty smí proměnná mít a co s nimi můžeš dělat. Čísla `12 + 3` dávají 15, zatímco texty `"12" + "3"` se spojí na `"123"`. Číslo sedadla může být označení, které jen tiskneš; počet sedadel je hodnota, se kterou počítáš.

## Typ zůstává stejný

Do `int count` můžeš uložit jiné celé číslo, ale ne text `"tři"`. Java na takovou chybu upozorní při překladu.

Můžeš potkat i zápis `var count = 3;`. Překladač z hodnoty odvodí `int`; neznamená to, že pak smíš do `count` uložit text. Pro první úlohy klidně piš typ přímo.

Další typy, například `long` pro větší celá čísla, budeme přidávat podle potřeby. Není nutné se teď učit jejich seznam nazpaměť.

## Přehled primitivních typů

Java má osm **primitivních typů**. Uchovávají samotnou jednoduchou hodnotu; `String` mezi ně nepatří.

| Typ | Co ukládá | Příklad |
|---|---|---|
| `byte` | Celé číslo od -128 do 127 | `byte level = 10;` |
| `short` | Celé číslo od -32768 do 32767 | `short year = 2026;` |
| `int` | 32bitové celé číslo, přibližně ±2,1 miliardy | `int count = 500;` |
| `long` | 64bitové celé číslo | `long total = 3000000000L;` |
| `float` | Přibližné desetinné číslo s menší přesností | `float ratio = 0.5F;` |
| `double` | Přibližné desetinné číslo s vyšší přesností | `double distance = 2.5;` |
| `char` | Jedna UTF-16 kódová jednotka | `char grade = 'A';` |
| `boolean` | Jen `true` nebo `false` | `boolean ready = true;` |

Přípony `L` a `F` určují typ literálu. Jednoduché uvozovky patří `char`, dvojité textu. Některé znaky, například část emoji, vyžadují více než jeden `char`; jeden viditelný symbol tedy nemusí znamenat jednu jednotku. Pro běžné názvy používej `String`, ne pole jednotlivých znaků.

## Referenční typy a null

Proměnná typu `String`, pole nebo vlastní třídy drží odkaz na objekt. `String name = null;` znamená chybějící odkaz; není to prázdný text `""` ani text `"null"`. Na `null` nemůžeš volat metody. Primitivní `int` hodnotu `null` nepřijímá.

Lokální proměnné nemají použitelnou implicitní hodnotu: musíš je před čtením přiřadit. Pole objektů a nově vytvořená pole hodnot naopak mají výchozí nulu, `false`, znak s kódem nula nebo `null` podle typu. Prakticky si to ukážeme u [polí](lesson:arrays) a [objektů](lesson:objects).

## Co se stane při překročení rozsahu

`int` má maximum `2147483647`. Přičtení jedné se přetočí na `-2147483648`, aniž by běžné sčítání vyhodilo výjimku. Když očekáváš větší hodnoty, zvol `long` už pro výpočet. Ani ten není nekonečný. `boolean` není číslo 0 nebo 1 a nelze ho na `int` přetypovat.

Zkus navrhnout typ pro číslo domu `12A`, počet knih, cenu v haléřích a přítomnost účtu. Odpověď závisí na významu: dům bude text, počet obvykle `int`, částka podle rozsahu `long` a přítomnost `boolean`. Samotný vzhled hodnoty typ neurčuje.

> [!OPTIONAL] Pod povrch: bity a přetečení
>
> **Bit** rozlišuje 0 a 1. Osm bitů má 256 různých kombinací. Java byte je interpretuje jako hodnoty od -128 do 127 pomocí dvojkového doplňku. U int je bitů 32 a rozsah nesymetrický: záporných hodnot je o jednu více než kladných.
>
> ```java
> int largest = Integer.MAX_VALUE;
> System.out.println(largest);     // 2147483647
> System.out.println(largest + 1); // -2147483648
> System.out.println(Integer.toBinaryString(5)); // 101
> ```
>
> `Integer.MAX_VALUE` je konstanta největšího int; `toBinaryString` vrací dvojkový zápis jako text. Součet se při přetečení drží v omezené bitové šířce. Nejde o náhodnou chybu konkrétního počítače ani o automatickou výjimku. Typ `boolean` má dvě možné hodnoty, ale z toho neplyne, že každá taková proměnná zabere v paměti přesně jeden bit. Java jednotnou velikost jejího uložení neurčuje.
>
> Velikosti všech číselných typů v bajtech, odvození rozsahů a rozdíl mezi signed a unsigned vysvětluje navazující dobrovolná lekce [Bity, bajty a znaménko](lesson:signed-unsigned).
