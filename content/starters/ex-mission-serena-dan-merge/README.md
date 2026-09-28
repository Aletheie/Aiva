# Serena a Dan potřebují obě úpravy

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Gossip Girl**

Serena upravila podobu newsletteru, aby odpovídal novému názvu redakce. Dan mezitím ošetřil článek bez titulku. Oba zasáhli stejný řádek, každý z dobrého důvodu, a teď jejich větve nejdou spojit automaticky.

Blair by nejraději prostě vybrala hezčí variantu a publikovala. Jenže jedna strana neobsahuje druhou opravu. Serena s Danem potřebují společnou verzi, která zachová nový vzhled i správné chování, aby se z vyřešeného konfliktu nestala další závada.

</details>
<!-- aiva-story:end -->

Serena upravila značku newsletteru, Dan opravil prázdný titulek. Git neví, jak spojit dvě verze stejného řádku. Pomoz zachovat oba záměry; volba celé jedné strany by jednu opravu zahodila.

## Tvůj úkol

Ve cvičné složce spusť `bash prepare.sh` (na Windows použij Git Bash). Vznikne nový lokální `merge-lab`, bez vzdáleného serveru. Skript odmítne přepsat existující složku. Přejdi do ní a spusť `git merge serena-edit`. Prohlédni konflikt v Newsletter.java, spoj pravidla a odstraň značky konfliktu: vždy prefix `Upper East Side | `, oříznutý titulek, pro prázdný text `(bez titulku)`. Spusť `javac Newsletter.java Check.java` a `java Check`; očekávej 3 kontroly. Potom `git add Newsletter.java` a `git commit -m "Spoj obe upravy newsletteru"`. Zkontroluj `git status`, `git log --graph --oneline --all` a rodiče merge commitu přes `git rev-list --parents -n 1 HEAD`.

## Připravené okolí

Skript vytvoří historii a obě větve jen uvnitř nové složky. Check.java kontroluje výsledné chování bez JUnit. Skript ani kontrolní soubor nemusíš upravovat.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Ověření dokonči podle konkrétních bodů níže.

## Kontrola

- [ ] Konflikt byl skutečně vytvořený mezi dvěma větvemi.
- [ ] Všechny 3 Java kontroly projdou, zachová se značka i prázdný titulek.
- [ ] Žádné konfliktové značky nezůstaly a git status je čistý.
- [ ] Poslední commit má dva rodiče; historie obou úprav se zachovala.
