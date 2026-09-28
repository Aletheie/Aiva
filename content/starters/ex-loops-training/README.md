# Jill kontroluje rozpis rádiového spojení

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Resident Evil**

Jill připravuje rádiovou zkoušku pro evakuační tým. V prostředí, kde kovové dveře a chodby snadno zkomplikují spojení, nechce spoléhat na neurčité „ozveme se za chvíli“. Každá skupina dostane své komunikační okno.

Při generálce ovšem poslední skupina nepřijde na řadu a plán navíc ukazuje ticho i po ukončení zkoušky. Jill si vedle sebe položí rozpis a skutečný průběh. Potřebuje součet, který zahrne všechna kola a jen pauzy, které mezi nimi opravdu nastanou.

</details>
<!-- aiva-story:end -->

Jill Valentine z Resident Evil připravuje rozpis rádiového spojení pro evakuační tým. Generátor vynechává poslední kolo a někdy přidá pauzu navíc. Oprav ho: první kolo trvá 20 sekund, každé další o 5 sekund déle. **Mezi** koly je pauza 30 sekund; po posledním už žádná.

Vstup je počet kol od 1 do 8. Vypiš každé kolo, pauzy a na konci celkový čas včetně pauz.
Pro dvě kola musí vzniknout:

```text
Kolo 1: 20 s
Pauza: 30 s
Kolo 2: 25 s
Celkem: 75 s
```

Použij jeden cyklus `for`, ne ručně rozepsaná kola. Zkus i jediné kolo: za ním žádná pauza být nesmí.

## Práce s úlohou

Otevři tuto složku v editoru. Java soubory jsou v `src/main/java`.
Použij JDK 21 nebo novější a před kontrolou soubory ulož.
Nápovědy a vysvětlené řešení jsou v aplikaci.
