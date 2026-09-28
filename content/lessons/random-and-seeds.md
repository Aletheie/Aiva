## Zopakuj stejné hody při hledání chyby

Dustinova hra hodí kostkou a po třetím hodu špatně spočítá body. Při opravě se hodí dostat znovu stejnou trojici hodů. **Pseudonáhodný generátor (pseudorandom generator)** totiž počítá posloupnost podle svého vnitřního stavu. Když začneš stejnou počáteční hodnotou, které se říká **seed**, a provedeš stejná volání, výsledky zopakuješ.

Celý soubor `Main.java`:

```java
import java.util.Random;

public class Main {
    public static void main(String[] args) {
        Random random = new Random(42L);
        for (int i = 0; i < 3; i++) {
            int die = random.nextInt(6) + 1;
            System.out.println(die);
        }
    }
}
```

Program vypíše 3, 4 a 1. Písmeno L označuje hodnotu typu long. Pro tuto třídu a stejnou posloupnost volání se stejným seedem dostaneš stejné výsledky. Neznamená to, že všechny různé generátory Javy používají stejný algoritmus.

## Horní mez se nepočítá

`nextInt(6)` vrací celé číslo od nuly včetně do šesti bez šestky. Přičtením jedné dostaneme běžnou kostku. `nextInt(names.length)` vybere platný index neprázdného pole. Prázdné pole nejprve ošetři: losování z nuly možností nedává smysl a nulová horní mez je neplatná.

`nextInt(10) + 5` vybírá 5 až 14. Než podobný výraz napíšeš, sepiš minimální a maximální výsledek. Pro velké obecné rozsahy se navíc může stát problémem přetečení při odčítání hranic; naše malé herní rozsahy tuto komplikaci nepotřebují.

## Pro jednu sérii použij jeden generátor

Vytvoř jeden Random před cyklem a předávej jej metodě, která ho potřebuje. Když v každém kole vytvoříš `new Random(42L)`, v každém kole začneš stejným prvním výsledkem. V našem příkladu by tak padala stále trojka: pokaždé bys odebrala první hod ze stejné série.

Pro běžné hraní můžeš vytvořit `new Random()` bez vlastního seedu. Pro reprodukci chyby zaznamenej seed i posloupnost operací. Přidané losování pro novou animaci by spotřebovalo další hodnotu a změnilo následné výsledky; proto je dobré různé nezávislé účely oddělovat.

## Jak ověřovat náhodné výsledky

Šest hodů nemusí ukázat každou stěnu právě jednou. Takové očekávání by tvořilo nespolehlivý test. Testuj rozsah, pevný známý scénář a pravidla programu. Pro balíček karet potřebuješ zamíchání bez opakování, nikoli opakovaný náhodný výběr s vracením. To jsou dva různé modely situace.

Random je vhodný pro tyto hry a výukové simulace. Nepoužívej jej pro hesla, přístupové tokeny nebo jiná tajemství; ty vyžadují kryptografický generátor SecureRandom a odpovídající návrh. Zpřístupněný seed zde slouží k ladění, nikoli k ochraně dat.

V procvičení si schválně zkus vytvořit generátor uvnitř metody roll a porovnej sérii. Porovnej výsledek s původními hody 3, 4 a 1 a najdi, který řádek začíná sérii pokaždé znovu.
