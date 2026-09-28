# Nela účtuje dopravu i za vyzvednutí

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

Nela přidala k e-shopu možnost vyzvednout samolepky osobně na příštím conu. Lea si rovnou objedná balíček a nabídne, že ho převezme u stánku. Pokladna jí přesto naúčtuje dopravu.

Při dalším pokusu někdo nakoupí přesně za hranici pro doručení zdarma a poplatek zůstane i tam. Nela má pravidla napsaná na webu docela jasně; jen každá část programu jako by četla jinou verzi. Potřebuje výpočet, na který se budou moci spolehnout všechny objednávky.

</details>
<!-- aiva-story:end -->

Nelin e-shop se samolepkami účtuje dopravu i lidem, kteří si pro objednávku přijdou sami. A přesně na hranici dopravy zdarma se pokladna chová podezřele. Pomoz jí opravit `static int shipping(int total, boolean pickup)` podle těchto pravidel:

- osobní odběr je vždy zdarma;
- zaslání je zdarma od 1000 Kč včetně;
- jinak stojí zaslání 79 Kč.

`main` už načítá částku (0–100000) a na dalším řádku `true` nebo `false` pro osobní odběr.
Metoda má cenu **vrátit**, nic nevypisovat. Výpis ponech v `main`.

Než začneš, předpověz cenu pro nákup 999 Kč se zasláním, 1000 Kč se zasláním a 100 Kč s osobním odběrem.
Pak ověř, že oprava řeší všechny tři situace. Například vstup `999` a `false` má vypsat jediný řádek `79`.

## Práce s úlohou

Otevři tuto složku v editoru. Java soubory jsou v `src/main/java`.
Použij JDK 21 nebo novější a před kontrolou soubory ulož.
Nápovědy a vysvětlené řešení jsou v aplikaci.
