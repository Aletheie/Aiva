# Wednesday odděluje pracovní kopii spisu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Wednesday**

Wednesday si chce vyzkoušet alternativní teorii k případu v Nevermore. Originál spisu zůstane u nástěnky, pracovní kopie má snést i odvážnější domněnky. Thing přidržuje poznámky a Enid navrhuje, aby alespoň jedna teorie nekončila podezřením na všechny.

Po úpravě kopie se však změní i původní přehled. Wednesday už nemá s čím svůj pokus porovnat. Než bude dál přesouvat podezřelé, potřebuje dvě skutečně oddělené verze; původní důkazy nesmějí následovat každý její experiment.

</details>
<!-- aiva-story:end -->

Wednesday potřebuje druhý spis pro alternativní teorii. Změna pracovního názvu nesmí přejmenovat původní spis ani změnit jeho ověření.

## Tvůj zásah

Oprav duplicate(CaseFile source,String label). Nevracej další odkaz na zdrojový objekt; vytvoř nový a zkopíruj potřebné údaje.

## Připravené okolí

CaseFile má přístupná pole label a verified. Main obstará vytvoření prvního objektu, změnu kopie a kontrolní výpis. Druhou změnou ověření záměrně odhaluje skryté sdílení. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Tři řádky: původní název, původní ověření true/false a název kopie. duplicate vrátí nový CaseFile s novým názvem a stejným ověřením. Main následně obrátí ověření pouze v kopii a vypíše oba spisy i totožnost. Názvy jsou neprázdné texty, mohou obsahovat mezery.

Ukázkový vstup:

```text
Les
true
Alternativa
```

Očekávaný výstup:

```text
Original: Les/true
Kopie: Alternativa/false
Stejny objekt: false
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
