# Spencer potřebuje zachovat celé číslo spisu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pretty Little Liars**

Spencer rozložila v pokoji vytištěné zprávy od „A“. Hanna přinesla jejich kopie a Aria doplnila poznámky k hlasovému záznamu. V Rosewoodu má každý detail potenciál změnit význam celé stopy, takže Spencer chce konečně společný přehled.

Po importu se ale štítek 0007 změní a z délky nahrávky zmizí půl minuty. Ostatní se ptají, zda jde o další záměrnou manipulaci. Spencer se nejdřív podívá, jaké datové typy program používá.

</details>
<!-- aiva-story:end -->

Spencer Hastings třídí kopie zpráv. Identifikátor 0007 se změnil na 7 a u délky nahrávky se ztratila půlminuta. Pomoz opravit typy záznamu.

## Tvůj zásah

Oprav deklarace a převody uvnitř označeného bloku. Kód je identifikátor, čas je měřená hodnota a ověření je logický údaj.

## Připravené okolí

Tři vstupní řádky už jsou připravené jako codeText, secondsText a verifiedText. Integer.parseInt a Boolean.parseBoolean zde můžeš použít podle připraveného vzoru. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Na třech řádcích přijde kód (1–12 číslic, může začínat nulou), délka v sekundách (0–3600) a true/false pro ověření. Vypiš kód beze změny, délku v minutách jako double a stav ověření. Sekundy děl 60.0.

Ukázkový vstup:

```text
0007
90
true
```

Očekávaný výstup:

```text
Spis: 0007
Minuty: 1.5
Overeno: true
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
