## Stejný obsah textu

Při přihlášení chceš zjistit, zda napsané jméno odpovídá uloženému. Dvě kartičky se jménem Ada mohou být různé kartičky, ale text na nich je stejný. V Javě pro porovnání obsahu textů použij `equals`:

```java
String name = "Ada";
System.out.println(name.equals("Ada")); // true
System.out.println(name.equals("ada")); // false
```

Velká a malá písmena se tu liší. `==` u textů nezjišťuje obecně shodný obsah; porovnává, zda odkazy míří na stejný objekt.

## Mezery kolem vstupu

```java
String original = "  Ada  ";
String clean = original.trim();
System.out.println(clean); // Ada
```

`trim()` vrátí text bez krajních běžných mezer. Mezery uvnitř jména nechá být. Prázdný řádek zůstane prázdným textem `""`.

## Výsledek je potřeba použít

Po vyčištění máme dvě hodnoty: původní zápis `"  Ada  "` v `original` a upravený `"Ada"` v `clean`. `trim()` původní text nepřepisuje. Kdybys napsala jen `original.trim();` a výsledek nikam neuložila ani nepoužila, při dalším výpisu `original` by mezery zůstaly.

Pokud program čeká příkaz `konec`, může porovnat `line.trim().equals("konec")`. Díky tomu nevadí mezery na okrajích.

## Metody, které budeme používat v projektech

Následující samostatné úryvky patří do `main`. Texty jsou neměnné; každá metoda vytvářející upravený text vrací výsledek, který musíš použít.

| Volání | Výsledek a význam |
|---|---|
| `"Java".length()` | 4, délka v UTF-16 jednotkách |
| `"Java".charAt(0)` | znak `J`, indexování od nuly |
| `"Java".substring(1, 3)` | `"av"`, od indexu 1 do 3 bez něj |
| `"Java".substring(2)` | `"va"`, od indexu 2 do konce |
| `"Java kurz".contains("kurz")` | true, obsahuje hledaný text |
| `"pridej Ada".startsWith("pridej ")` | true, začíná uvedeným textem |
| `"Main.java".endsWith(".java")` | true, končí uvedenou příponou |
| `"".isEmpty()` | true, délka je nula |
| `"  ".isBlank()` | true, jen bílé znaky nebo prázdný text |
| `" Ada ".strip()` | `"Ada"`, odstraní krajní bílé znaky podle pravidel Javy |
| `"Ada".equalsIgnoreCase("ADA")` | true, porovnání bez velikosti písmen |
| `"a-b".replace("-", " ")` | `"a b"`, nahrazení doslovného textu |

`trim()` odstraňuje z okrajů znaky s kódem nejvýše U+0020. `strip()` rozpozná širší sadu bílých znaků, ale ne úplně každý viditelný druh mezery. `charAt` a `substring` kontrolují rozsah indexů; příliš velký index vyvolá chybu. Na prázdném textu proto nelze číst první znak.

## Rozdělení vstupu a zpětné spojení

```java
String command = "pridej 120 Java kurz";
String[] parts = command.split(" ", 3);
System.out.println(parts[0]); // pridej
System.out.println(parts[1]); // 120
System.out.println(parts[2]); // Java kurz
System.out.println(String.join(" | ", parts)); // pridej | 120 | Java kurz
```

`split(oddělovač, limit)` vrací pole textů. Kladný limit 3 dovolí nejvýše tři části, takže zbytek názvu zůstane spolu. Bez druhého argumentu se koncové prázdné části odstraňují; limit -1 je zachová. V projektu TSV proto používáme `line.split("\t", -1)`.

První argument `split` je **regulární výraz**, pravidlo hledání v textu. `"\\s+"` znamená jednu nebo více běžných bílých mezer rozpoznaných tímto regexem. Tečka je speciální znak, takže doslovnou tečku rozdělíš pomocí `"\\."`. Dvojité lomítko je kvůli Java textovému literálu, ne dva požadované znaky ve vstupu. Před čtením `parts[2]` ověř délku pole.

`String.join(oddělovač, části)` spojí texty vložením oddělovače mezi ně. `toLowerCase(java.util.Locale.ROOT)` a `toUpperCase(java.util.Locale.ROOT)` převádějí velikost písmen podle neutrálních pravidel místo náhodného nastavení počítače. `Locale.ROOT` je konstanta pro jazykově neutrální kontext, vhodná například pro technické příkazy.

Pro nulový odkaz používej nejdřív kontrolu `text != null`. Zápis `"konec".equals(text)` je také bezpečný a pro null vrátí false, zatímco `text.equals("konec")` by selhal. Uvědom si rozdíl mezi chybějícím textem, prázdným textem a textem se samými mezerami.

> [!OPTIONAL] Pod povrch: String a Unicode
>
> Textové API indexuje String pomocí UTF-16 jednotek. Jeden viditelný symbol může zabrat dvě jednotky nebo kombinaci více znaků. Vyzkoušej:
>
> ```java
> String face = "😀";
> System.out.println(face.length()); // 2
> System.out.println(face.codePointCount(0, face.length())); // 1
> ```
>
> `codePointCount(od, do)` počítá Unicode kódové body ve zvoleném rozsahu, horní index je vyloučen. Ani počet kódových bodů obecně není počet člověkem vnímaných symbolů; složené emoji nebo písmeno s kombinující diakritikou může tvořit více bodů.
>
> Neměnnost String dovoluje bezpečné sdílení textu. Když v cyklu mnohokrát připojuješ další části, použij `StringBuilder`: `new StringBuilder()` vytvoří měnitelný zásobník textu, `append("A")` přidá část a `toString()` vytvoří výsledný String. Nevyvozuj z neměnnosti konkrétní interní počet bajtů každého textu; implementace JVM může úložiště optimalizovat.
