# Zkouškové pod kontrolou (StudyDesk)

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

Lea má před zkouškovým povinnosti na papíru, v telefonu i v rozepsané zprávě sobě samé. Jeden úkol už dokončila dvakrát, protože pokaždé našla jiný seznam. Ema navrhne udělat z těchto poznámek malou společnou aplikaci.

StudyDesk má uchovat hotovou práci, ukázat další kroky a přežít změnu plánu i vypnutí počítače. Připravený základ už existuje. Lea do něj potřebuje přidat dokončování, přejmenování a filtrování úkolů. Chce také ověřit, že se změny zachovají po vypnutí programu.

</details>
<!-- aiva-story:end -->

Lea má před zkouškovým úkoly v pěti poznámkách a v hlavě další tři. Pomoz jí dokončit StudyDesk: seznam, který si pamatuje hotovou práci, ukáže jen to, co zbývá, a zvládne i změnu plánu. V připravené aplikaci doplníš změny úkolů, filtrování a testy.

## Připravená aplikace

StudyDesk už umí přidat a vypsat studijní úkoly, uložit je do JSON a znovu načíst. Projekt obsahuje Maven, datové typy, službu `TaskService`, rozhraní úložiště (Repository), implementaci s Gson a první testy v JUnit.

Nejdřív spusť stávající testy a projdi `README.md` a `PROJECT.md`. Tam najdeš příkazy a způsob spuštění.

## Co doplnit

- Dokončení a znovuotevření úkolu podle stálého ID.
- Filtrování podle stavu a změnu názvu s kontrolou prázdného textu.
- Výběr datového souboru argumentem programu a srozumitelné chyby načtení či zápisu.
- Alespoň osm dalších testovacích případů, včetně poškozeného JSON, duplicitních ID a selhání zápisu.

Při chybných datech zachovej původní soubor. Změnu v paměti potvrď až po úspěšném uložení, aby aplikace netvrdila, že se neuložený úkol zachová po restartu.

## Ověření a předání

Přidej dva úkoly, jeden dokonči a zobraz jen otevřené. Aplikaci restartuj a ověř oba úkoly i jejich stav. Na kopii JSON vyzkoušej poškozená data. Potom spusť `mvn package` a výsledný JAR mimo IDE.

Ukládej menší změny do Gitu a doplň README s příkazy, spuštěním a omezeními. Aplikace pracuje místně pro jednoho uživatele a jeden proces. První sestavení Mavenem potřebuje stáhnout závislosti; tento projekt kontroluješ v IDE nebo přes Maven.

Navazuje na objekty, rozhraní, JSON a testování (Testing). Přiložené řešení je doporučený postup rozšíření, nikoli hotový finální program.

## Kontrola

- [ ] Třídy pro úkoly, operace nad nimi a ukládání dat jsou oddělené.
- [ ] Dokončení, filtr a změna názvu fungují přes stabilní ID.
- [ ] Data a stavy přežijí restart.
- [ ] Chybný JSON ani chyba disku nevedou k tiché ztrátě dat.
- [ ] Maven testy pokrývají i chybové případy.
- [ ] Git historie a README popisují skutečné funkce i omezení.
