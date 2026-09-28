# Kat potřebuje dva pohledy na stejné výsledky

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Deset důvodů, proč tě nenávidím**

Kat pomáhá s literární soutěží na Padua High a trvá na tom, aby výsledky dávaly smysl i bez společenské popularity účastníků. Pro čtenáře chce přehled jmen a bodů, pro vlastní kontrolu potřebuje stejné dvojice obráceně.

Při přípravě druhého pohledu se však začne přepisovat první. Kat má dost důvodů kritizovat školní pořadí i bez programu, který mění data během prohlížení. Potřebuje dvě použitelné podoby stejného výsledku a možnost zkoušet opravy bez zásahu do originálu.

</details>
<!-- aiva-story:end -->

Kat Stratford z Deseti důvodů, proč tě nenávidím připravuje výsledky literární soutěže. Jednou potřebuje dvojici jméno/body, podruhé body/jméno. Nová verze bodů nemá přepsat původní záznam.

## Tvůj zásah

Oprav generický Pair bez raw typů a přetypování. Typový parametr se při swapped musí obrátit spolu s hodnotami.

## Připravené okolí

Main už vytváří Pair<String,Integer> a při obrácení očekává Pair<Integer,String>. Přiřazení do Integer ověří, že změna není pouze kosmetická. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: jméno na řádku, původní body 0–1000 a nové body 0–1000. Pair<A,B> ukládá dvě hodnoty. swapped vrací nový Pair<B,A>, withRight vrací nový Pair<A,B> s původní levou a novou pravou hodnotou. Originál zůstává beze změny. Main používá oba konkrétní typy a vypíše tři pohledy.

Ukázkový vstup:

```text
Kat
12 15
```

Očekávaný výstup:

```text
Puvodni: Kat/12
Obracene: 12/Kat
Zmena: Kat/15
Stejny objekt: false
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. AIVA porovnává výstup programu s více vstupy.
