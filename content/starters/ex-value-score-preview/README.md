# Dustin zkouší bonus nanečisto

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Stranger Things**

Dustin navrhl pro herní turnaj bonus a chce partě ukázat, jak by změnil výsledky. Mike trvá na tom, že se o pravidle nejdřív hlasuje. Will proto vedle skutečné výsledkovky připraví místo pro náhled.

Jenže po otevření náhledu už body přibyly i ve skutečném pořadí. Lucas navrhne otevřít ho ještě několikrát, když to tak hezky funguje. Dustin musí rychle obnovit rozdíl mezi zkouškou a potvrzenou změnou, jinak se z turnaje stane soutěž v klikání.

</details>
<!-- aiva-story:end -->

Dustin vylepšil turnajovou hru o náhled bonusu: každému skóre přičte bod, ale změna má platit až po potvrzení. Teď stačí náhled otevřít a skutečné výsledky se přepíšou. Pomoz mu opravit náhled dřív, než si toho všimnou ostatní hráči.

Oprav `static int[] incrementedCopy(int[] values)`. Vrať **nové pole** se všemi hodnotami zvýšenými o 1.
Původní pole nesmíš měnit. `main` a jeho výpisy ponech.

Vstup je počet hodnot (0–20) a pak jednotlivá skóre (0–1000), každé na vlastním řádku.
Pro počet 3 a skóre 2, 4, 6 má připravený výpis ukázat:

```text
Puvodni: [2, 4, 6]
Nahled: [3, 5, 7]
Stejne pole: false
```

Fungovat musí i prázdné pole: obě hodnoty jsou `[]`, ale stále jde o dva různé objekty.
`Arrays.toString(...)` ve starteru jen vypisuje pole, není potřeba jej upravovat.

## Práce s úlohou

Otevři tuto složku v editoru. Java soubory jsou v `src/main/java`.
Použij JDK 21 nebo novější a před kontrolou soubory ulož.
Nápovědy a vysvětlené řešení jsou v aplikaci.
