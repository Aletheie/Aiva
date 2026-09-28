# Wednesday a tajný kód

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Wednesday**

Enid připravila pro Wednesday novou místnost textové únikovky. Uvnitř stojí trezor, Věc ťuká do klávesnice a vedle leží vzkaz, že kombinace se dá odvodit z odpovědí zařízení. Wednesday konečně vypadá alespoň mírně zaujatě.

Trezor má po každém pokusu naznačit směr dalšího hledání. Zatím však nikdo nenaprogramoval jeho rozhodování ani okamžik otevření. Wednesday potřebuje po každém tipu správnou nápovědu a po uhodnutí kódu otevřené dveře.

</details>
<!-- aiva-story:end -->

Wednesday našla v tvé textové hře trezor s kódem od 1 do 100. Hrubá síla ji nudí. Napiš hru, která po každém tipu napoví „výš“ nebo „níž“, počítá platné pokusy a po uhodnutí skončí.

## 1. Jeden tip

Začni tajným číslem 42. Přečti jeden číselný tip. Vypiš „hledej větší číslo“, „hledej menší číslo“ nebo „správně“.

## 2. Více pokusů

Přidej cyklus while a počítadlo. Po uhodnutí vypiš počet platných pokusů a skonči. Tip `-1` hru ukončí bez započítání. Čísla mimo 1–100 také nezapočítávej.

## 3. Náhodné číslo

Až vše funguje, místo 42 použij `new Random().nextInt(100) + 1` a nad třídu přidej `import java.util.Random;`. Tento připravený nástroj vybere číslo od 1 do 100.

## Vyzkoušej

S pevným číslem 42 zadej 1, 100 a 42: správné rady a 3 pokusy. V nové hře ověř `-1` a tip mimo rozsah. Pak vrať náhodný výběr.

**Dobrovolně navíc:** příkaz `konec`, nečíselný vstup a nová hra. To využívá pozdější látku; základní hra přijímá čísla.

## Použité nástroje a jejich výklad

Random, nextInt, break a continue, parsování vstupu a volitelné zachytávání chyb.

## Kontrola

- [ ] Tipy 1 a 100 dostanou správné porovnání vůči 42.
- [ ] Správný tip ukončí hru a ukáže počet pokusů.
- [ ] Ukončení nezpůsobí nekonečnou smyčku.
- [ ] Základní hra funguje; bonusová validace není povinná.
