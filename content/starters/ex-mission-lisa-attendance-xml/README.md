# Lisa odmítá nejednoznačný XML záznam

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Simpsonovi**

Lisa importuje seznam účastníků školní debaty. U jednoho záznamu jsou dvě různá jména, u dalšího někdo odpověděl na potvrzení účasti dlouhou větou. Bart tvrdí, že to aspoň působí osobněji.

Program zatím vezme první údaj, který se mu hodí, a zbytek si nějak vyloží. Lisa by raději věděla, který záznam je nejednoznačný. Podle počtu potvrzených účastníků pak připraví místa v sále.

</details>
<!-- aiva-story:end -->

Lisa Simpson importuje účastníky školní debaty. Dvakrát uvedené jméno ani libovolný text vydávaný za boolean nesmějí projít jako správná účast.

## Tvůj zásah

Oprav ParticipantMapper.read(Document). Kontroluj počty elementů před item/get a rozliš chybějící, prázdné a duplicitní hodnoty.

## Připravené okolí

SafeXml je připravený parser s vypnutými externími přístupy. Children.named vrací jen přímé potomky požadovaného jména. Jejich implementaci ponech; opravuješ význam načtených dat, ne parser. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup je jeden XML dokument na jednom řádku. Kořen musí být participant s neprázdným id po trim. Musí mít právě jednoho přímého potomka name a jednoho present. Jméno po trim nesmí být prázdné; present po trim musí být přesně true nebo false. Další elementy ignoruj. Vrať Participant; main vypíše id:jméno:PRITOMEN nebo NEPRITOMEN. Porušení pravidel vyhoď jako IllegalArgumentException, main vypíše NEPLATNY ZAZNAM. Chybu XML syntaxe řeší parser samostatně jako NEPLATNE XML.

Ukázkový vstup:

```text
<participant id="7"><name> Lisa &amp; Bart </name><present>true</present></participant>
```

Očekávaný výstup:

```text
7:Lisa & Bart:PRITOMEN
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
