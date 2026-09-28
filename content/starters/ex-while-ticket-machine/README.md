# Poslední tramvaj, poslední drobné

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

Koncert skončil, Nela má ještě v hlavě poslední refrén a na zastávce svítí čas poslední tramvaje. Lea hlídá příjezd, zatímco Nela vysype do dlaně drobné na lístek.

Automat po první minci poděkuje a přestane poslouchat, přestože k ceně jízdenky ještě kus chybí. Takový závěr koncertního večera si parta nepředstavovala. Program potřebuje vydržet přijímat platby, dokud má proč, a na konci srozumitelně vyřešit i případný přeplatek.

</details>
<!-- aiva-story:end -->

Nela se vrací z koncertu a automat na lístky přijímá jednu platbu za druhou. Pomoz naprogramovat jeho platební část: nevíš předem, kolik mincí nebo bankovek vhodí, ale jakmile je zaplaceno, automat má vrátit přeplatek a přestat čekat na další peníze.

První řádek vstupu je cena lístku (1–1000 Kč). Další řádky jsou kladné hodnoty vložených mincí
nebo bankovek (1–200 Kč). Vstup vždy obsahuje dost peněz; na konci nic dalšího nečti.
Po platbě, která ještě nestačí, vypiš `Zbyva: X`. Jakmile je zaplaceno, vypiš jen `Vratit: X` a skonči.

Pro cenu 20 a platby 5, 10, 10:

```text
Zbyva: 15
Zbyva: 5
Vratit: 5
```

Při přesné platbě má být vrácená částka 0. Před první platbou žádnou zprávu nevypisuj.

## Práce s úlohou

Otevři tuto složku v editoru. Java soubory jsou v `src/main/java`.
Použij JDK 21 nebo novější a před kontrolou soubory ulož.
Nápovědy a vysvětlené řešení jsou v aplikaci.
