# Blair počítá pozvánky podle kódu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Gossip Girl**

Blair dostala seznam pozvánek z pokladny a druhý od Sereny. Oba obsahují stejnou kartičku, jen jednou přišel kód s jinými mezerami a velikostí písmen. Při sloučení se host v evidenci objeví dvakrát.

To je přesně druh drobnosti, který se u dveří změní ve velkou scénu. Blair potřebuje poznat tutéž pozvánku podle jejího upraveného kódu, přestože ji do aplikace přinesly dva různé importy. Kopie potvrzení nesmí vyrábět další místo v sále.

</details>
<!-- aiva-story:end -->

Blair dostala dvě kopie téže pozvánky z různých importů. Po normalizaci kódu mají být jedna hodnota, přestože jde o dva objekty.

## Tvůj zásah

Oprav equals a hashCode; ponech kód neměnný. Nestačí přimět equals vracet true, pokud hashové hledání používá jinou hodnotu.

## Připravené okolí

HashSet v main ověří, že se pozvánky se stejným kódem neukládají dvakrát. Pracuje přes equals a hashCode; jeho interní algoritmus není součástí úlohy. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Dva řádky obsahují neprázdné kódy s případnými okrajovými mezerami. Invitation ukládá trim a velká písmena přes Locale.ROOT. Rovnost porovnává normalizovaný kód a pouze objekty Invitation. HashCode musí odpovídat stejné hodnotě. Main vloží oba objekty do HashSet a ověří hledání novou kopií prvního kódu.

Ukázkový vstup:

```text
 a7 
A7
```

Očekávaný výstup:

```text
Rovne: true
Pocet: 1
Kopie nalezena: true
Rovno textu: false
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
