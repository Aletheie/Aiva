## Od nápadu ke třem krokům

Nela prodává samolepky a chce spočítat cenu po uplatnění kupónu. Její postup je krátký: vezmi cenu nákupu, odečti slevu a vypiš částku k zaplacení. Takovému přesnému postupu říkáme **algoritmus (algorithm)**.

```java
System.out.println(300 - 50);
```

Program vypíše `250`.

## Výraz a příkaz

`300 - 50` je **výraz (expression)**: spočítá hodnotu.

Celý řádek `System.out.println(300 - 50);` je **příkaz (statement)**: provede akci, tady výpis. Samotné `300 - 50;` není platný Java příkaz.

Pravidlům zápisu říkáme **syntaxe (syntax)**. Zatím hlídej hlavně uvozovky, závorky a středníky.

## Funguje i jiné zadání?

Vyzkoušej cenu 300 a slevu 0. Výsledek má být 300.

Co když je cena 100 a sleva 150? Výpočet dá −50, ale zadání musí říct, jestli slevu odmítnout, nebo cenu omezit na nulu. Správný zápis sám nezaručuje správné pravidlo.

Před psaním kódu si připrav jeden běžný příklad a jeden případ na hranici. Později z nich mohou vzniknout testy.

Použijeme stejnou kostru jako u [prvního programu](lesson:hello-world). Tentokrát nás zajímá postup uvnitř ní.

## Statické a dynamické typování

Java kontroluje typy hlavně při překladu. Deklarace `int count = 3;` říká, že `count` uchovává celé číslo; pozdější `count = "tři";` je chyba překladu. V dynamicky typovaném jazyce, například Pythonu, může stejné jméno postupně odkazovat na různé typy hodnot. Ani tam to neznamená, že každá operace nad každou hodnotou dává smysl.

Zápis `var count = 3;` v Javě jen nechá překladač odvodit typ `int` z počáteční hodnoty. Není to přepnutí do dynamického typování. Java i C++ jsou staticky typované jazyky, ale liší se mimo jiné běhovým prostředím a běžným způsobem správy paměti; stejné závorky neznamenají totožná pravidla.

## Blok a rozsah platnosti

Složené závorky vytvářejí **blok**. Jméno lokální proměnné je použitelné od deklarace do konce jejího bloku, čemuž říkáme **scope**. Tento úryvek patří do `main`:

```java
int price = 300;
{
    int discount = 50;
    System.out.println(price - discount); // 250
}
System.out.println(price); // 300
```

Vnitřní blok vidí vnější `price`. Za jeho koncem ale není dostupné `discount`. Odsazení pomáhá člověku poznat vnoření; hranici pro překladač určují závorky. Samotný středník může představovat prázdný příkaz, takže nepatří automaticky za každou zavírací závorku.

## Které vstupy má výpočet přijmout

U slevy si zapiš: vstupní cena je nezáporná, sleva je od nuly do ceny, výstup je cena po odečtení. To jsou předpoklady a očekávaný výsledek. Pro cenu 300 a slevu 50 očekávej 250, pro slevu 300 nulu. Hodnota slevy 400 už porušuje vstupní pravidlo a vyžaduje rozhodnutí aplikace.

Zkus postup nejdřív vyjádřit běžnou češtinou, pak sestavit Java výraz. Například rozhodni, zda kupón vyšší než cena nákupu odmítneš, nebo ho omezíš na cenu. Dokud to není jasné, nevíš, který výsledek máš v programu ověřovat.
