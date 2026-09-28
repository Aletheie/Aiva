# AIVA · Fluent desktop

**Zdrojový přepis 0.2.0 z C++/Qt do Flutteru a Dartu. Jediný UI kit: `fluent_ui` 4.16.1.**

Offline český kurz Javy s lokálním progresem, externím IDE a lokální kontrolou uloženého studentského kódu. Vývoj na macOS, Windows build na Windows, Linux build na Linuxu.

Aktuální macOS verze byla sestavena a ověřena Flutter testy, skutečným JDK i nativním integračním testem. Podrobnosti a hranice ověření jsou v [VERIFICATION](docs/VERIFICATION.md).

## Co aplikace obsahuje ve zdrojích

Rozhraní tvoří nativní komponenty Fluent UI, modrý akcent, jemný acrylic v navigaci a vyhledávacím dialogu a neprůhledné plochy pro čtení. Mac nemá samostatnou horní lištu; systémová tlačítka a oblast pro tažení okna jsou v sidebaru. Hledání vlevo nebo přes Cmd/Ctrl+K rozumí českým i anglickým pojmům bez diakritiky. Aplikace používá pouze Fluent UI a základní Flutter widgety; přibalený Material icon font je závislost interních ovládacích prvků `fluent_ui`.

Acrylic používá přímo widget `Acrylic` z `fluent_ui` a rozostřuje obsah uvnitř okna. Lze ho vypnout; vysoký kontrast ho vypíná automaticky. Výklad má pevný podklad. Integrační test pořizuje skutečné screenshoty světlého i tmavého režimu, vyhledávání, lekcí, projektů a velkého písma v menším okně.

Domovská stránka, mapa kurzu, vyhledávání bez diakritiky, oblíbené, nedávné lekce, čtečka s obsahem, cvičení, šest projektů, progres a nastavení mají vlastní implementaci. Každé otevření lekce začíná nahoře. Nic neuzamyká lekce podle předpokladů. Dokončení lekce je ruční a nezávislé na dokončení cvičení.

Lokální služby: detekce JDK a IDE, ruční výběr, vytvoření workspace bez přepisu řešení, otevření IntelliJ/VS Code, SQLite s migracemi, záloha a import původního profilu, `javac`/`java` s časovým limitem, limitem výstupu a zrušením. Studentské programy **nejsou sandboxované**.

## Obsah kurzu

Kurz postupuje od úplných základů k týmovému Java projektu. Lekce obsahují souvislé programy, rozbor použitých metod, další varianty a hraniční případy. Původní výklady jsou v mediánu 2,7× obsáhlejší i bez dobrovolných doplňků. Do hloubky lze pokračovat v 21 rozbalovacích okénkách, například o bajtkódu, paměti, referencích nebo hašování. Přehled pokrytí osnovy je v [mapě učiva](docs/CURRICULUM.md).

Cvičení řeší konkrétní situace: Jill kontroluje zásoby, Spencer opravuje evidenci důkazů, Caroline zachraňuje neuloženou změnu a Serena s Danem řeší skutečný Git konflikt. Střídají se opravy větších připravených programů, doplnění funkcí, návrh pravidel i testy, které musí odhalit záměrnou chybu. Každé téma má nejvýše čtyři úlohy; 13 publikovaných lekcí nabízí jen výklad a ukázky. Rozšíření přidalo 81 cvičení s novými ID, existující studentské soubory se nepřepisují. [Pravidla zadání](docs/EXERCISE_VOICE.md) popisují tón a práci s připraveným kódem.

| Obsah | Počet |
|---|---:|
| Kapitoly osnovy | 33 |
| Plné publikované lekce | 78 |
| Z toho hlavní cesta | 45 |
| Z toho dobrovolné mezisekce | 33 |
| Výslovně plánované lekce | 0 |
| Cvičení v lekcích | 171 |
| Z toho lokální kontrola výstupu | 97 |
| Vstupně-výstupní případy | 418 |
| Volitelné projekty | 6 |

Šest projektových úloh se počítá zvlášť od 171 cvičení. K rozšířeným 156 úlohám přibylo 15 dalších příběhových misí v nových lekcích. Dobrovolné mezisekce a projekty neovlivňují procenta hlavní cesty. Kapitola Vychytávky nabízí šest lekcí včetně náhody a opakovatelného seedu. Hlavní cesta nově výslovně učí null a balíčky/importy. JSON, XML, YAML, lambdy, streamy, Gradle, TDD/Mockito a souhrnné pokročilé opakování jsou dobrovolné. Další odbočky pokrývají datum a čas, regex, řazení, Optional, HTTP, SQL/JDBC, souběžnost a distribuci JAR. Celý kurz zobrazuje vše přímo bez přepínače připravovaných témat.

Závěrečný StudyDesk má Maven, Gson a JUnit starter; projektové checklisty jsou manuální. Aplikace nepředstírá obecný Maven/JUnit judge. Maven testy projektu se spouštějí v externím IDE nebo terminálu.

## První spuštění na Macu

Nainstaluj Flutter stable (pro tento zdrojový snapshot je v `.flutter-version` uvedeno **3.47.0**), Xcode s command-line tools a nástroje, které požaduje `flutter doctor -v`. Pro Java cvičení nainstaluj JDK 21 nebo novější. Samotné čtení kurzu JDK nevyžaduje.

V rozbalené složce projektu:

```sh
bash scripts/setup_macos.sh
flutter run -d macos
```

Setup provede následující:

```sh
dart tool/bootstrap.dart
flutter pub get
flutter doctor -v
```

Bootstrap vytvoří do dočasného projektu oficiální desktop hosty přes `flutter create --no-pub`, přenese **jen chybějící** `macos/`, `windows/`, `linux/`, nastaví názvy/ikony a přidá macOS overlays. Nemění `lib/`, kurz ani existující nativní přizpůsobení. Při nečekané změně povinné části Flutter šablony skončí chybou místo tichého vytvoření chybného hosta.

`pubspec.lock` i nativní platformní adresáře jsou součástí projektu. Při zavedení verzování je ulož spolu se zdroji; setup existující nativní přizpůsobení nepřepisuje.

Pro vývoj otevři kořen projektu ve VS Code nebo IntelliJ s Flutter/Dart podporou. Hot reload používá běžný Flutter workflow. Windows kvůli macOS vývoji nepotřebuješ.

### Kontroly na Macu

```sh
dart format lib test integration_test tool
flutter analyze
dart tool/content_index.dart --check
export JAVA_HOME="$(/usr/libexec/java_home -v 21)"
export AIVA_REQUIRE_JDK_TESTS=1
flutter test --reporter expanded
flutter test integration_test/app_test.dart -d macos
```

Používáš-li jiné JDK 21+, uprav `JAVA_HOME`. Procesové testy hledají Dart uvnitř Flutter SDK; při nestandardní instalaci nastav `DART_EXECUTABLE` na skutečný binární soubor Dart, nikoli shellový wrapper.

## Windows build na Windows

Flutter SDK a **Visual Studio s workloadem Desktop development with C++** jsou potřeba pro nativního hosta a pluginy Flutteru. Nestačí samotné VS Code. Setup nevytváří Windows build na Macu.

```powershell
./scripts/setup_windows.ps1
flutter run -d windows
flutter test --reporter expanded
flutter build windows --release
```

Hotový výstup po úspěšném buildu je v `build/windows/x64/runner/Release/`. Distribuuje se **celá složka**, ne samotné `.exe`.

Portable ZIP a klasický Inno Setup instalátor:

```powershell
./scripts/package_windows.ps1
```

Pro instalátor je potřeba Inno Setup 6; pouze ZIP:

```powershell
./scripts/package_windows.ps1 -ZipOnly
```

Skript hledá redistribuovatelné MSVC CRT knihovny instalovaného Visual Studia, přidá je vedle aplikace, ověří základní bundle a volitelně podepíše výsledek. Certifikáty nejsou součástí projektu. Balení nebylo v tomto prostředí spuštěno; čistý Windows stroj bez vývojářských nástrojů je nutná release kontrola.

## macOS a Linux balíčky

```sh
# Na Macu: .app a vývojový .dmg; signing/notarizace jsou volitelné.
bash scripts/package_macos.sh

# Na Linuxu s build dependencies Flutteru: .deb.
bash scripts/package_linux.sh
```

AppImage vzniká navíc, pokud je nastavený `LINUXDEPLOY` a dostupný oficiální GTK plugin. CI má krok pro jejich stažení a vytvoření AppImage. Více v [PACKAGING](docs/PACKAGING.md). Linux DEB používá standardní systémové balíčky pro GTK a knihovny systému; nevyžaduje Flutter/Dart SDK. AppImage není záruka kompatibility se všemi starými distribucemi či verzemi glibc.

Student instalující správně sestavený distribuční balíček nemá instalovat Flutter, Dart, CMake ani C++ compiler. JDK a externí IDE jsou nástroje pro samotné Java úlohy, nikoli runtime AIVA. Python slouží pouze pro doplňkové vývojové ověření a není runtime aplikace.

## Data a přechod z C++ verze

Profil leží v systémovém application-support adresáři z `path_provider`, databáze se jmenuje `progress.sqlite`. Přesnou cestu ukazuje **Nastavení → Data a zálohy**; tlačítko otevře složku profilu. Výchozí workspace je v dokumentech uživatele, `AIVA/exercises`. Data nejsou v instalační složce. Pro izolovaný testovací profil lze nastavit `AIVA_PROFILE` na absolutní cestu.

Při přechodu na AIVA aplikace rozpozná profil, výchozí workspace i značky cvičení z předchozí verze a používá je na původním místě. Uložený postup a studentské soubory se nepřesouvají ani nepřepisují. Nové instalace používají názvy AIVA.

Původní C++ aplikaci nejdřív zavři. V nové aplikaci zvol **Importovat progres** a vyber důvěryhodnou původní `progress.sqlite` nebo její konzistentní zálohu. Import čte verze schématu 1–3, vytvoří zálohu současného profilu, sloučí vyšší dokončené stavy a příznaky. Stávající preference mají přednost. Souhlas se spouštěním kódu se neimportuje.

Ve workspace nastavení vyber původní **kořenovou složku cvičení**, ne složku jediné úlohy. Zachovaná ID a `.aiva-workspace.json` umožňují znovu používat studentské soubory. Existující řešení se nedoplňuje ani nepřepisuje; ani soubor, který student záměrně smazal, se neobnovuje.

## Struktura

```text
lib/
  app/             controller a FluentApp
  domain/          staticky typované modely, stavy, editace profilu
  content/         JSON/Markdown model, parser, asset index, Java lexer
  persistence/     SQLite schema a izolovaný adaptér
  platform/        cesty, procesy, otevření odkazu/složky
  services/        JDK/IDE, workspace, kontrola Java úloh
  ui/              shell, design tokeny, komponenty a stránky
content/           český kurz, cvičení, projekty a startery
test/              Dart unit, widget, SQLite a procesové testy
integration_test/  nativní start, perzistence a skutečné screenshoty
tests/java-solutions/  referenční řešení pro kontrolu runneru
tool/              SDK-only bootstrap a generátor asset indexu
platform_overlays/ macOS host nastavení před generováním
packaging/         ikony, Inno Setup a desktop metadata
scripts/           setup, balení a nezávislé kontrolní skripty
docs/              architektura, bezpečnost, obsah, ověření
```

## Přidání lekce nebo cvičení

Kurz používá původní JSON schéma a Markdown. Novou lesson definici uveď v `content/course.json`, přidej text, příklady, obtížnosti, cvičení a případné starter soubory. Všechna ID musí být globálně jedinečná. Publikovaná lekce musí mít skutečný výklad, příklad a běžné chyby. Cvičení přidej jen tam, kde má smysl. Následně:

```sh
dart tool/content_index.dart
flutter test test/content
```

Index explicitně zahrnuje i hluboko vnořené a skryté soubory starterů. Bez jeho aktualizace by nový soubor nebyl v balíčku. Přesný postup a validace jsou v [CONTENT](docs/CONTENT.md).

## CI a release stav

`.github/workflows/desktop.yml` připravuje samostatné Windows/macOS/Linux joby, analyzer, testy, JDK 21, nativní integrační scénář se screenshoty a balíčky. Lokální macOS kontroly prošly; samotné GitHub Actions ani balení pro Windows/Linux zde spuštěné nebyly. Závislosti jsou zamčené v `pubspec.lock`. AppImage helpery v CI používají pohyblivé upstream reference a zaznamenávají SHA-256; pro stabilní veřejný release je zamkni na prověřené konkrétní revize.

Před distribucí zbývá ověřit balíčky na čistých cílových systémech, systémové čtečky obrazovky a release licence podle [VERIFICATION](docs/VERIFICATION.md).

## Dokumentace a primární zdroje

[Architektura](docs/ARCHITECTURE.md) · [Design](docs/DESIGN.md) · [Obsah](docs/CONTENT.md) · [Bezpečnost](docs/SECURITY.md) · [Testování](docs/TESTING.md) · [Balení](docs/PACKAGING.md) · [Přenos funkcí](docs/PARITY.md) · [Ověření](docs/VERIFICATION.md)

Technické API při přepisu bylo konzultováno s primární dokumentací: [fluent_ui](https://bdlukaa.github.io/fluent_ui/), [API fluent_ui](https://pub.dev/documentation/fluent_ui/4.16.1/), [Flutter desktop](https://docs.flutter.dev/platform-integration/desktop), [Windows deployment](https://docs.flutter.dev/platform-integration/windows/building), [macOS deployment](https://docs.flutter.dev/platform-integration/macos/building), [Dart Process](https://api.dart.dev/dart-io/Process-class.html), [sqlite3](https://pub.dev/packages/sqlite3). Dokumentace SDK není dokladem úspěšného sestavení tohoto projektu.
