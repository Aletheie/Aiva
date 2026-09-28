## Kde najdeš kód cvičení

`Main.java` je textový soubor s Java kódem. **Přípona** `.java` říká, o jaký druh souboru jde. Složka může obsahovat více souborů i dalších složek.

**Cesta (path)** ukazuje, kde soubor najdeš. Ve cvičeních potkáš například:

```text
src/main/java/Main.java
```

To znamená postupně otevřít složky `src`, `main`, `java` a v nich soubor `Main.java`.

## Kterou složku otevřít v editoru

Otevři celou složku připraveného cvičení. Může obsahovat i `README.md` s pokyny. **Workspace** je místo, kde AIVA tato cvičení připravuje.

Cvičení s lístky i cvičení s knihami mohou mít soubor `Main.java`. Jsou ale v různých složkách, podobně jako dvě fotky pojmenované `foto.jpg` ve dvou albech. Když ve výsledku nevidíš změnu, zkontroluj celou cestu v editoru: možná právě upravuješ jiné cvičení.

Soubor nejdřív ulož. Zavření editoru a uložení nejsou totéž.

## Relativní a absolutní cesta

`src/main/java/Main.java` je relativní cesta: její začátek závisí na aktuální složce. Absolutní cesta uvádí umístění od kořene, například `/Users/ada/kurz/Main.java` nebo `C:\kurz\Main.java`. Konkrétní počítač má jiné adresáře; cizí absolutní cestu proto obvykle nekopíruj.

Složka projektu sdružuje zdroje, konfiguraci a případné testy. Složka workspace může obsahovat mnoho takových projektů. Soubory stejného jména v různých cvičeních nejsou propojené: změna jednoho neupraví ostatní.

## Co upravovat a co vzniká automaticky

`Main.java` je zdrojový text, `Main.class` výsledek překladu. `pom.xml` popisuje Maven projekt a `README.md` pokyny pro člověka. Adresáře `target` a `build` obvykle obsahují generované výsledky. Nevkládej do nich jediné kopie svého řešení; nástroj je může při čistém sestavení smazat.

V editoru si zapni zobrazení přípon. Soubor `Main.java.txt` není Java zdroj, i když správce souborů poslední příponu skryje. Velikost písmen zachovávej přesně; některé systémy rozlišují `Main.java` a `main.java`.

Zkus najít cestu aktuálního souboru, nadřazený projekt a místo, kde vzniká překlad. Není třeba nic přesouvat. Cílem je umět vysvětlit, který soubor se při kontrole skutečně čte.
