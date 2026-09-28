# Mína se přidává do hry

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh Aiva**

Ve hře z útulku už se představuje pes, ale Ema nakreslila také kočku Mínu. Lea zkusí zkopírovat psí kód a po první úpravě získá kočku, která stále někde štěká.

Jméno a základní chování mají obě zvířata společné; vlastní hlas potřebuje každé zvlášť. Lea by ráda přidala Mínu tak, aby při příští změně nemusela obíhat všechny kopie stejného programu. Útulek se má časem rozrůst a opravování kočičího štěkotu by se rychle omrzelo.

</details>
<!-- aiva-story:end -->

Lea píše malou hru se zvířaty. Pes už v ní má jméno i hlas, kočka Mína zatím chybí. Pomoz ji přidat bez kopírování celé třídy psa.

Ke třídám `Animal` a `Dog` přidej `Cat`: jméno předej konstruktoru předka a `sound()` přepiš tak, aby vracela `mňau`. Použij `@Override`; jméno čti přes zděděnou metodu.

V `main` vytvoř Mínu a vypiš `Mína: mňau`. Ověř, že původní pes dál funguje a kočka si neukládá druhou kopii jména.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Cat volá konstruktor předka.
- Zvuk se přepisuje, jméno se znovu neukládá.
- Výstup odpovídá očekávání.
