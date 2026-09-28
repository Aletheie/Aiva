# Výlet bez hádky o peníze

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

Nela plánuje společný výlet po filmových lokacích. Každá účastnice potřebuje vlastní vstupenku, dopravu si ale parta zaplatí dohromady. V chatu už koluje několik nadšených souhlasů a tři různé představy o konečné ceně.

První verze kalkulačky účtuje celý odvoz každé osobě zvlášť. Výlet tím získá rozpočet hollywoodské produkce, přestože jede obyčejný mikrobus. Nela proto oddělí ceny za jednotlivce od společného výdaje a chce konečně poslat částku, podle které se dá rozhodnout.

</details>
<!-- aiva-story:end -->

Nela plánuje s kamarádkami jednodenní výlet. Jedna cena je za každý vstup, druhá za dopravu celé party — a skupinový chat už nabízí tři různé výsledky. Pomoz jim spočítat rozpočet jednou pořádně.

Napiš kalkulačku, která načte **tři řádky**: počet lidí (1–50), vstupné za osobu (0–2000 Kč) a dopravu pro celou skupinu (0–10000 Kč). Na okrajích řádků mohou být mezery.

Vypiš celkovou cenu jako celé číslo a orientační podíl na osobu jako `double`.
Podíl nezaokrouhluj; rozdělení skutečných plateb po korunách zde neřešíme.
Pro vstup `3`, `120`, `150` je výstup:

```text
Celkem: 510
Na osobu: 170.0
```

Každé číslo čti pomocí `nextLine()`, očisti `trim()` a převeď `Integer.parseInt(...)`.
Nevypisuj výzvy k zadání. Mysli i na výlet bez vstupného a na cenu, která se nerozdělí na celé koruny.

## Práce s úlohou

Otevři tuto složku v editoru. Java soubory jsou v `src/main/java`.
Použij JDK 21 nebo novější a před kontrolou soubory ulož.
Nápovědy a vysvětlené řešení jsou v aplikaci.
