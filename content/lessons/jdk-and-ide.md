## Co potřebuješ nainstalovat

Potřebuješ **JDK 21 nebo novější** pro spuštění Javy a **editor / IDE** pro psaní kódu, například IntelliJ IDEA nebo VS Code.

## Nastavení v AIVA

1. Otevři **Nastavení → Java a editor**. Pokud JDK nemáš, použij odkaz na jeho instalaci.
2. Zvol **Vyhledat nástroje** a vyber JDK.
3. Vyber také editor, ve kterém chceš psát.

Pokud hledání JDK nic nenajde, vyber jeho složku ručně. Musí obsahovat `bin/java` i `bin/javac` (na Windows s příponou `.exe`). Na Macu bývá uvnitř `Contents/Home`.

## Ověř první spuštění

Na záložce **Cvičení** otevři úlohu „Ověř první spuštění Javy“. Připrav soubory a otevři je v editoru. Zatím nic neměň. Kontrola má získat jediný řádek:

```text
Pripraveno
```

Při první kontrole aplikace požádá o povolení spouštět tvůj kód na počítači.

## Když kontrola nefunguje

Ověř, že editor i AIVA používají zvolené JDK alespoň verze 21. Editor si JDK nastavuje zvlášť.

Po každé změně **ulož soubor**. AIVA kontroluje uložené soubory ve složce daného cvičení. Pokud vidíš starý výstup, zkontroluj i to, kterou složku upravuješ.

Než vybereš instalaci, můžeš si připomenout [rozdíl mezi JDK a JVM](lesson:how-java-works).

## IDE není běhové prostředí

**IDE (Integrated Development Environment)** spojuje editor, správu projektu, spuštění a debugger. Například opravený pozdrav nejdřív napíšeš a uložíš v editoru. Po stisknutí Run použije IDE nástroje z JDK: přeloží soubor a spustí ho. Barevné zvýraznění textu tedy může fungovat, i když ještě není vybrané JDK. VS Code je editor, pro pohodlnou práci s Javou potřebuje odpovídající Java rozšíření; projekt v IntelliJ také musí mít nastavené SDK.

V terminálu můžeš ověřit `java --version` a `javac --version`. Oba příkazy mají být dostupné a pro kurz alespoň verze 21. Pokud funguje jen `java`, můžeš mít pouze runtime nebo nesprávně nastavenou cestu k nástrojům. Proměnná prostředí **PATH** určuje, ve kterých adresářích shell hledá spouštěné příkazy. Výběr JDK v AIVA se od PATH terminálu může lišit.

## Když se výsledky v editoru a AIVA liší

Otevři připravenou úlohu jako projekt, najdi `src/main/java/Main.java`, změň jen text uvnitř uvozovek a ulož. Spusť v IDE a porovnej s kontrolou AIVA. Pokud IDE výsledek změnilo, ale AIVA ne, zkontroluj cestu ke cvičení a uložený soubor. Pokud obě prostředí hlásí chybu překladu, čti první chybu v kódu.

Základní cvičení používají standardní Javu. Pozdější Gson, JUnit a YAML příklady vyžadují závislosti a běžný build v IDE nebo terminálu; vysvětlí je [Maven](lesson:maven-overview). Samotné přidání `import` chybějící knihovnu nestáhne.

Příprava je hotová, když dokážeš soubor najít, upravit, uložit, spustit a přečíst chybu. Nemusíš teď znát všechna nastavení editoru.
