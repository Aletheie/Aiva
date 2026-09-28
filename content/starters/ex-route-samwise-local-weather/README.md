# Sam nechce vyrazit podle chybové stránky

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pán prstenů · současná variace**

Sam připravuje věci na další úsek cesty s Frodem a vedle jídla řeší počasí. V této malé současné variaci má mapa zkušební službu s předpovědí. Sam by ocenil včas vědět, zda přibalit něco proti dešti; mokré zásoby už nejsou lákavější ani po dlouhém pochodu.

Klient však přečte zprávu o neznámém místě nebo poruše jako normální počasí. Sam potřebuje poznat, kdy dostal skutečnou předpověď a kdy mu služba zatím nic užitečného neřekla.

</details>
<!-- aiva-story:end -->

Sam z Pána prstenů plánuje cestu a testuje službu s předpovědí. Starý klient považuje každou odpověď za počasí, takže i zpráva o poruše vypadá jako pěkný den. Rozliš úspěšnou odpověď, neznámé místo a poruchu služby.

Doplň `forecast(HttpClient client, URI uri)`. Odešli GET s limitem požadavku dvě sekundy. Pro status 200 vrať `Predpoved: ` a očištěné tělo odpovědi. Pro 404 vrať `Misto nenalezeno`. Pro ostatní statusy vrať `Sluzba nedostupna: ` a číslo statusu. Chybové tělo nevydávej za předpověď. IOException a InterruptedException nech předat volajícímu; chybu spojení nesmíš převést na slunečno.

Starter obsahuje hotový LocalWeatherServer, který běží pouze na tomto počítači, vybírá volný port a při ukončení se zavře. Internet ani účet nepotřebuješ. Server neměň. Spuštění Main musí vypsat:

```text
Predpoved: jasno
Misto nenalezeno
Sluzba nedostupna: 503
```

V debuggeru ověř status i tělo všech tří odpovědí. Rozliš jejich HTTP chybu od IOException při nedostupném spojení. Kontrola je ruční, protože AIVA zde nespouští síťový scénář jako běžné konzolové zadání. Viz [HTTP klient](lesson:http-client).

## Spuštění

JDK 21+, bez Maven závislostí. Server se spustí a zastaví uvnitř programu.

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java src/main/java/LocalWeatherServer.java
java -cp out Main
```

Příkazy spusť v terminálu ze složky cvičení; v AIVA potvrď checklist podle skutečného výsledku.

## Ověření

- Tři řádky odpovídají očekávanému výstupu pro 200, 404 a 503.
- Požadavek má timeout a klient connectTimeout.
- Chybové tělo se nezobrazuje jako počasí a výjimka spojení se nemaskuje.
- Program po skončení uvolní server i klienta.
