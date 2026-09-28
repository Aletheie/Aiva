# Kolik bonusových bodů tým získal?

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Původní příběh AIVA**

Po turnaji chce Ema ukázat, kolik bonusů parta získala za zvláštní úkoly. V záznamech jsou ale pohromadě odměny, penalizace i kola bez změny. Lea zkusí všechno sečíst a dostane jiné číslo, než Ema potřebuje.

Konečné skóre už má vlastní tabulku. Pro tentokrát jde jen o získané bonusy, aby bylo vidět, které výzvy se povedly. Přehled proto musí nejdřív poznat správné záznamy a teprve z nich sestavit součet.

</details>
<!-- aiva-story:end -->

Na herním večeru padají bonusy i penalizace. Ema teď potřebuje jen součet získaných bonusů, ne konečné skóre po odečtení trestů. Pomoz vybrat správná data.

Pro `List.of(-2, 0, 3, 7)` sečti kladná čísla nejprve cyklem a potom pomocí `filter` a `reduce`. Obě varianty mají vrátit `10`.

Ověř také prázdný seznam a seznam samých záporných hodnot: v obou případech tým nezískal žádný bonus, takže výsledek je `0`. Vstupní seznam ponech beze změny.

## Spuštění

Otevři složku jako Maven projekt v IDE. Použij JDK 21 nebo novější a jazykovou úroveň 21. Příklad spusť jeho hlavní třídou. Kontrola této úlohy je ruční podle checklistu.

Výchozí soubory obsahují příklad z výkladu. Uprav ho podle zadání a kontroluj běžné i hraniční vstupy.

## Ověření

- Dvě varianty vracejí 10.
- Prázdný a záporný vstup vrací 0.
- Nevkládám vedlejší účinky do map nebo filter.
