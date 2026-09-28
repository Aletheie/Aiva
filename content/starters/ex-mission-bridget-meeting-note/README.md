# Bridget nechce ztratit druhou půlku jména

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Deník Bridget Jones**

Bridget si zapsala schůzku do deníku, na lepicí lístek i do nové aplikace. Považuje to za mimořádně organizovaný den. Potom otevře přehled a zjistí, že část jména skončila v poznámce a samotná poznámka kamsi zmizela.

V redakci právě zvoní telefon a někdo se ptá, na koho čeká. Bridget má dost trapných situací zajištěných osobně; software jí nemusí vyrábět další. Potřebuje, aby údaje přešly z klávesnice do správných kolonek i tehdy, když jméno obsahuje mezeru.

</details>
<!-- aiva-story:end -->

Bridget Jones si zapisuje setkání. Program po prvním slově jména přeskočí zbytek řádku a poznámka se ocitne v poli pro místo.

## Tvůj zásah

Oprav tři čtení vstupu. Žádná část programu nesmí načíst jen první slovo nebo vynechat prázdnou poznámku.

## Připravené okolí

Scanner je už vytvořený. Main následně formátuje záznam; do tohoto výpisu nezasahuj. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Tři řádky obsahují celé jméno, místo a poznámku. Každý může obsahovat mezery, poznámka smí být prázdná. Vypiš tři označené řádky přesně jako ve vzoru. Zachovej i mezery uvnitř textu; nic automaticky nečisti.

Ukázkový vstup:

```text
Mark Darcy
U knihkupectvi
Dorazi po praci
```

Očekávaný výstup:

```text
Jmeno: Mark Darcy
Misto: U knihkupectvi
Poznamka: Dorazi po praci
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
