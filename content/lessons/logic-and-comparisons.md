## Porovnání vrací odpověď

```java
int age = 18;
boolean adult = age >= 18;
System.out.println(adult); // true
```

`>` je větší, `<` menší, `>=` a `<=` zahrnují rovnost. `==` porovnává rovnost čísel, `!=` nerovnost.

Pozor na rozdíl: `=` hodnotu ukládá, `==` porovnává.

## Dvě pravidla dohromady

Blair kontroluje vstup do zákulisí benefice. Pro tuto ukázku platí: návštěvnici musí být alespoň 18 let a potřebuje lístek nebo pozvánku. Člověk u dveří tedy klade dvě otázky: „Je ti alespoň 18?“ a „Máš jeden z požadovaných dokladů?“

```java
boolean hasTicket = false;
boolean hasInvitation = true;
boolean mayEnter = age >= 18 && (hasTicket || hasInvitation);
```

- `&&` znamená **a zároveň**: musí platit obě strany.
- `||` znamená **nebo**: stačí jedna strana, mohou platit i obě.
- `!` znamená **ne**: `!hasTicket` je tady `true`.

Část v závorce odpoví, zda má návštěvnice lístek nebo pozvánku. `&&` tuto odpověď spojí s věkem. Pozvánka tedy nestačí sedmnáctileté návštěvnici; podmínka věku musí platit vždy. Dospělá návštěvnice se dvěma doklady projde také, protože `||` dovoluje obě možnosti současně.

## Nejprve si pravidlo řekni nahlas

Pak dosaď konkrétní hodnoty. Zkus třeba věk 17 s lístkem a věk 18 bez lístku i pozvánky. V obou případech má vyjít `false`.

U textu se rovnost obsahu zapisuje jinak: `name.equals("Ada")`. S tím se podrobněji seznámíš v [práci s textem](lesson:text-tools).

Pokud se ti plete typ `boolean` s číslem nebo textem, připomeň si [datové typy](lesson:types).

## Pravdivostní tabulka

| a | b | a && b | a || b |
|---|---|---|---|
| false | false | false | false |
| false | true | false | true |
| true | false | false | true |
| true | true | true | true |

`!true` je `false` a obráceně. Složenou podmínku lze ověřit dosazením každé možné dvojice. Pravidlo „od 10 do 20 včetně“ zapisujeme `value >= 10 && value <= 20`, nikoli matematickým řetězcem `10 <= value <= 20`, který v Javě nedává typový smysl.

## Zkrácené vyhodnocení

`&&` nevyhodnotí pravou stranu, pokud už vlevo dostane `false`; `||` ji nevyhodnotí, pokud vlevo dostane `true`. Této vlastnosti říkáme **short-circuit**. V `main` vyzkoušej:

```java
int divisor = 0;
boolean divides = divisor != 0 && 12 % divisor == 0;
System.out.println(divides); // false, bez dělení nulou
```

Pořadí kontrol je důležité. Opačný zápis by se pokusil dělit ještě před ověřením nuly. Operátory `&` a `|` nad booleany vyhodnocují obě strany; pro běžné podmínky používej `&&` a `||`.

## Negace a čitelnost

`!(age < 18)` je stejné pravidlo jako `age >= 18`. Negace „má lístek a má doklad“ je „nemá lístek nebo nemá doklad“: `!(ticket && id)` odpovídá `!ticket || !id`. Změna `&&` při negování celé podmínky není kosmetická; zachovává její význam.

Rovnost textu patří do [práce s textem](lesson:text-tools). U desetinných výpočtů se navíc přesné `==` může lišit kvůli reprezentaci; tolerance závisí na konkrétním požadavku. Pro začátek předpověz vstup do sálu pro čtyři kombinace lístku a pozvánky a zkontroluj také věkovou hranici 18.

> [!OPTIONAL] Pod povrch: zkrácené vyhodnocení je řízení toku
>
> Pravá strana `&&` nemusí být vůbec spuštěna. Nejde jen o rychlejší verzi operátoru; může to ovlivnit výsledek programu, pokud výraz něco mění.
>
> ```java
> int calls = 0;
> boolean allowed = false && ++calls > 0;
> System.out.println(allowed); // false
> System.out.println(calls);   // 0
> ```
>
> Prefix `++calls` by nejdřív zvýšil hodnotu, ale sem se vyhodnocování nedostane. Povinnou práci proto nedávej do druhé části podmínky. Bajtkód může tyto situace provádět skoky mezi instrukcemi; pro programátorku je rozhodující zaručené pořadí a případné přeskočení, nikoli konkrétní procesorová instrukce.
