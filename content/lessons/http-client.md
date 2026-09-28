## Klient se ptá, server odpovídá

Pro plán hobití výpravy chceme načíst počasí v Kraji. Náš program jako **klient (client)** pošle dotaz na adresu `/shire`; cvičný **server** odpoví „jasno“. **HTTP** určuje podobu požadavku a odpovědi. **API** služby říká, na kterou adresu se ptát, jakou metodu použít a co může přijít zpět.

Požadavek obsahuje metodu, například `GET`, cílovou URI, hlavičky a případně tělo s daty. Odpověď má stavový kód, hlavičky a případné tělo. V naší ukázce je tělem obyčejný text; jiné API může používat JSON.

GET slouží k načtení, POST často k vytvoření nebo provedení operace, PUT k náhradě a DELETE k odstranění. Konkrétní význam určuje API. Před opakováním neúspěšného požadavku musíš vědět, zda už server nemohl změnu provést; automaticky zopakovaný nákup může vytvořit dva nákupy.

## Nejprve status, potom data

Status 200 běžně znamená úspěch, 404 nenalezený zdroj a 503 dočasně nedostupnou službu. Skupina 2xx označuje úspěšné odpovědi. V dokumentaci služby si ověř, které stavové kódy vrací a zda odpověď obsahuje data. Odpověď 204 například tělo nemá. Poškozený JSON v úspěšné odpovědi je další samostatná chyba, kterou musíš ověřit.

Následující celý `Main.java` se spouští s hotovým `LocalWeatherServer.java` ze starteru této lekce. Server běží lokálně a metoda uri sestaví adresu včetně právě přiděleného portu:

```java
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class Main {
    public static void main(String[] args) throws Exception {
        try (LocalWeatherServer server = new LocalWeatherServer();
             HttpClient client = HttpClient.newBuilder()
                     .connectTimeout(Duration.ofSeconds(2)).build()) {
            HttpRequest request = HttpRequest.newBuilder(server.uri("/shire"))
                    .timeout(Duration.ofSeconds(2)).GET().build();
            HttpResponse<String> response = client.send(request,
                    HttpResponse.BodyHandlers.ofString());
            System.out.println(response.statusCode()); // 200
            System.out.println(response.body()); // jasno
        }
    }
}
```

HttpClient patří do JDK. Builder sestaví neměnný požadavek, send na tomto vlákně počká na odpověď a BodyHandlers.ofString přečte tělo jako text. Pro malé známé odpovědi je to pohodlné. U velkých nebo nedůvěryhodných dat je potřeba také limit přijatých bajtů; timeout sám neomezuje velikost a řetězec drží celé tělo v paměti.

## Dva časové limity a dvě kategorie chyb

`connectTimeout` omezuje navazování nového spojení. Timeout požadavku omezuje čekání na odpověď v rámci této operace. Neomezené čekání by mohlo nechat aplikaci působit zaseknutě. Jednoho klienta používej pro více požadavků a po skončení jeho práce ho uzavři; příklad používá Java 21 try-with-resources.

IOException signalizuje například neúspěšný přenos. InterruptedException znamená přerušení čekajícího vlákna: zde ji předáváme dál. Pokud ji v jiném programu zachytíš, obvykle přerušení obnovíš pomocí Thread.currentThread().interrupt() a práci ukončíš. Odpověď 404 znamená, že se server ozval, ale požadovaný zdroj nenašel. Je to jiná situace než vypnutý server, od kterého žádná odpověď nepřišla.

## Procvičování bez cizího serveru

Lokální server používá HTTP pouze na 127.0.0.1 a má pevné malé odpovědi. Pro vzdálenou skutečnou službu použij HTTPS, řiď se její dokumentací a neposílej tokeny do veřejných logů. Nezveřejňuj skutečná osobní data kvůli zkoušení API.

Nejdřív otestuj úspěch, chybový status a nedostupné spojení. Teprve potom přidej převod těla přes [JSON](lesson:json-overview). K pochopení chování klienta nepotřebuješ účet u veřejného poskytovatele ani živá data z internetu.
