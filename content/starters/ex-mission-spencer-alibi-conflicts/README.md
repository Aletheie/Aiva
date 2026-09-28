# Spencer porovnává různé verze alibi

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Pretty Little Liars**

Spencer porovnává svědectví k jednomu časovému úseku v Rosewoodu. Stejná informace se dostala do společného chatu, do poznámek i na vytištěný list. Hanna při pohledu na počet záznamů prohlásí, že tolik rozporů nemůže být náhoda.

Jenže několik kopií stejného místa si neodporuje. Podezřelé je až to, když se jedna osoba objevuje na různých místech zároveň. Spencer potřebuje oddělit opakované zprávy od skutečného konfliktu, než začne někoho vyslýchat kvůli obyčejnému přeposlání.

</details>
<!-- aiva-story:end -->

Spencer Hastings sesbírala několik záznamů pro tentýž časový úsek. Opakovaný zápis stejného místa není rozpor, dvě různá místa pro stejnou osobu už ano.

## Tvůj zásah

Doplň summarize(List<Alibi>). Využij mapu osob a množinu míst pro každou osobu; nepočítej výskyty místo různých hodnot.

## Připravené okolí

Main už načítá neměnné záznamy Alibi a vypisuje vrácené řádky. TreeMap řadí klíče přirozeným pořadím; HashSet uchová každé místo jen jednou. Pracuj mezi komentáři `UPRAVUJ ODSUD` a `UPRAVUJ POTUD`; ostatní části zachovej.

## Pravidla a ověření

Vstup: počet záznamů 0–40 a dvojice osoba/místo, každá hodnota je jedno slovo. Seskup místa podle osob, duplicitní místa počítej jednou. Osoby vypiš přirozeně seřazené podle jména jako osoba:pocetMist:OK pro jediné místo nebo osoba:pocetMist:ROZPOR pro více. Pro nula záznamů vypiš BEZ ZAZNAMU. Zdrojový seznam neměň.

Ukázkový vstup:

```text
4 Hanna Kino Aria Skola Hanna Kino Hanna Park
```

Očekávaný výstup:

```text
Aria:1:OK
Hanna:2:ROZPOR
```

Výsledky počítej z dat. Nevypisuj další výzvy; kontrola porovnává i formát.

## Práce v editoru

Použij JDK 21 nebo novější. Pracuj v této cvičné složce a před kontrolou soubory ulož. Aiva porovnává výstup programu s více vstupy.
