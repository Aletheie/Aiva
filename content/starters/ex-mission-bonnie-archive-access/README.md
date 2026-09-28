# Bonnie zavírá boční vstup do archivu

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Upíří deníky**

Bonnie prochází rodinné zápisky a porovnává je s městským archivem Mystic Falls. Caroline jí pomohla připravit obyčejný digitální seznam lidí, kteří smějí používat badatelnu. Tentokrát nerozhodují kouzla ani pravidla pro vstup upírů do domu, jen správa archivních účtů.

Při zkoušce projde boční cestou i účet, který měl být zablokovaný. Bonnie zavře starý zápisník a podívá se na obrazovku. Tajemství v archivu je dost; oprávnění čtenářů už další záhadu nepotřebují.

</details>
<!-- aiva-story:end -->

Bonnie Bennett spravuje přístup k městskému archivu. Nejde o pravidla upírů: v této úloze je to obyčejný systém oprávnění. Pozvánka nyní omylem obchází zablokovaný účet.

## Tvůj zásah

Oprav dvě logické podmínky access a review. Obě mají vracet boolean bez větvení if.

## Připravené okolí

Čtení čtyř logických údajů i jejich výpis obstarává main. Procvičuješ závorky, &&, || a ! v souvislém programu. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Čtyři hodnoty true/false: má průkaz, má pozvánku, účet je zablokovaný, je otevřeno. Přístup povol pouze v otevírací době, bez blokace a s alespoň jedním dokladem. Druhý výstup review je true právě tehdy, když je otevřeno, účet není blokovaný, ale chybí oba doklady.

Ukázkový vstup:

```text
false true false true
```

Očekávaný výstup:

```text
Vstup: true
Overit: false
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
