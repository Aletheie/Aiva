# Dustinova hra má dvě různá menu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Stranger Things**

Dustin a Mike převedli část své stolní výpravy do textové hry. Na začátku vítá hráče hezké menu, po návratu z první místnosti však konzole nabídne jeho starou verzi. Will upozorní, že mapa světa se může měnit, ale ovládání by nemuselo.

Dustin totiž upravil jen jedno ze dvou míst, kam stejné menu kdysi opsal. Teď už plánuje další herní možnosti a tuší, jak rychle by ztratil přehled. Než přidá další chodbu, chce zařídit, aby menu stačilo upravit na jednom místě.

</details>
<!-- aiva-story:end -->

Dustin dal do vaší textové hry menu před startem i po dohrání. Jenže upravil pouze jednu kopii a hráči teď vidí dvě různé verze pravidel. Sjednoť obě menu: přesuň ho do `static void printMenu()` a zavolej tuto metodu na obou místech. Napiš ji vedle `main`, ne dovnitř. Výstup má být:

```text
1 - Nova hra
2 - Pravidla
0 - Konec
Hra dohrana.
1 - Nova hra
2 - Pravidla
0 - Konec
```

Text jednotlivých položek má být v kódu napsaný jen jednou. Hláška o dohrání zůstane v `main`.
Zkus si potom v editoru přejmenovat jednu položku menu: změna se má projevit na obou místech.
Automatická kontrola porovnává výstup; umístění metody a odstranění kopie si zkontroluj v kódu.

## Práce s úlohou

Otevři tuto složku v editoru. Java soubory jsou v `src/main/java`.
Použij JDK 21 nebo novější a před kontrolou soubory ulož.
Nápovědy a vysvětlené řešení jsou v aplikaci.
