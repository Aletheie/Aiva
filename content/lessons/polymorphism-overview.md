## Každá zpráva zná svůj text

Aplikace má zobrazit uvítání a připomenutí. Cyklus se každé zprávy zeptá `text()` a vypíše odpověď. Uvítání vrátí „Vítej“, připomenutí jinou větu. Stejné volání tak spouští různé provedení podle objektu. Tomu se říká **polymorfismus (polymorphism)** a navazuje na [přepisování metod](lesson:inheritance-overview).

## Typ proměnné a skutečný objekt

Celý příklad v `Main.java` používá běžné dědění a pole objektů:

```java
class Message {
    public String text() {
        return "Zpráva";
    }
}

class Welcome extends Message {
    @Override
    public String text() {
        return "Vítej";
    }

    public String language() {
        return "čeština";
    }
}

class Reminder extends Message {
    @Override
    public String text() {
        return "Čas na procvičení";
    }
}

public class Main {
    public static void main(String[] args) {
        Message[] messages = {new Welcome(), new Reminder()};
        for (Message message : messages) {
            System.out.println(message.text());
        }
        Message first = messages[0];
        if (first instanceof Welcome welcome) {
            System.out.println(welcome.language());
        }
    }
}
```

Výstup má tři řádky: `Vítej`, `Čas na procvičení`, `čeština`. Proměnná `message` má při překladu typ `Message`. Překladač proto dovolí metodu `text()`, kterou tento typ zná. Za běhu se podle skutečného objektu vybere tělo z `Welcome` nebo `Reminder`. Tomu říkáme **dynamický výběr metody (dynamic dispatch)**.

Přiřazení `Message first = new Welcome()` objekt nijak nepřetváří ani neořezává. Ukládá odkaz na potomka do proměnné typu předka; jde o bezpečné rozšíření typu reference. Statické typování přitom platí dál: `first.language()` by se nepřeložilo, protože třída `Message` takovou metodu nemá.

## Ověření typu před speciální operací

`instanceof Welcome welcome` současně ověří typ a vytvoří proměnnou `welcome` s užším typem pro větev `if`. To je **pattern matching**, zde jednoduché přiřazení jména objektu, který odpovídá typu. Pro `null` je podmínka `false`.

Starší zápis by byl `if (first instanceof Welcome) { Welcome welcome = (Welcome) first; }`. Závorky `(Welcome)` jsou explicitní **přetypování reference**. Pokud skutečný objekt není odpovídajícího typu, pokus vyvolá `ClassCastException`. Přetypováním připomenutí na `Welcome` z něj uvítací zprávu neuděláš. Měníš jen typ, přes který se snažíš k existujícímu objektu přistupovat. Kdykoli stačí společná `text()`, nepřetypovávej.

## Co se dynamicky nevybírá

Instanční přepsané metody se vybírají za běhu. Přetížené varianty se vybírají při překladu podle typů argumentů. Pole a statické metody také nemají toto polymorfní chování. Proto v návrhu vystavuj operace, ne veřejná pole stejného jména v předkovi a potomkovi.

## Proč to pomáhá testování

Program zpracovávající `Message` nemusí znát všechny její potomky. Přidání `Goodbye` se stejnou `text()` nevyžaduje úpravu cyklu. Podobně lze při testování použít úložiště v paměti místo souboru. Obě úložiště přitom poskytují stejné metody, které popíšeme [rozhraním](lesson:interfaces-overview).

Doplň třetí zprávu a ověř, že stačí rozšířit pole. Pak si napiš, jak by stejný problém vypadal s řetězcem `if` podle typu. U cyklu s `text()` stačí, aby nová zpráva tuto metodu poskytla. Do cyklu už nemusíš dopisovat další větev pro rozloučení.

> [!OPTIONAL] Pod povrch: jak se vybere metoda
>
> Překladač ověří, že deklarovaný typ dovoluje konkrétní podpis volání. JVM pak u běžné přepsané instanční metody respektuje skutečný typ objektu. Implementace může používat tabulky metod nebo optimalizované přímé volání, když bezpečně zná cílový typ. Není předepsané, že každá JVM musí pokaždé procházet seznam všech tříd.
>
> JIT někdy prokáže, že se na místě volání vyskytuje jediná implementace, a optimalizuje ho. Pokud se později objeví objekt jiného typu, JVM musí zavolat jeho přepsanou metodu. Výkon tedy neposuzuj jen podle toho, zda je proměnná typu rozhraní.
