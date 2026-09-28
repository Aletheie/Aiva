# Alenka hledá dvě místa vedle sebe

<!-- aiva-story:start -->
<details>
<summary>Příběh v pozadí</summary>

**Alenka v říši divů**

Alenka dorazí na podivné divadelní představení. Bílý králík spěchá k pokladně, Kloboučník už někomu vyměnil místo a každá řada má jiný počet sedadel. Plánek sálu vypadá, jako by ho kreslilo několik lidí během čajového dýchánku.

Alenka chce najít dvě volná místa vedle sebe. Program ale občas považuje konec jedné řady a začátek další za sousedy. To by se při společném sledování hry těžko vysvětlovalo. Nejdřív musí začít respektovat skutečný tvar jednotlivých řad.

</details>
<!-- aiva-story:end -->

Alenka a Kloboučník z Alenky v říši divů jdou do divadla. Sál má každou řadu jinak dlouhou, takže počet sedadel musíš u každé řady zjistit zvlášť. Najdi jim dvě volná sousední sedadla ve stejné řadě.

Doplň `findPair(int[][] seats)`. Nula je volné místo, jednička obsazené. Vrať první dvojici při procházení řad od začátku a sedadel zleva. Číslování výpisu začíná jedničkou. Nikdy nespojuj konec jedné řady se začátkem další a nic v poli neměň. Pokud dvojice chybí, vrať `Plno`.

Starter čte počet řad 0–20. Pro každou řadu následuje délka 0–20 a právě tolik hodnot 0/1. Řady nejsou null. Pro vstup:

```text
3
3 0 1 0
4 1 0 0 1
1 0
```

očekáváme `Rada 2, sedadla 2 a 3`. Prázdný sál vypíše `Plno`. Vstup i výpis už jsou hotové; uprav jen hledání. Viz [pole polí](lesson:nested-arrays).

## Spuštění

JDK 21 nebo novější. Otevři složku v editoru, doplň místa TODO a ulož soubory.
V Aiva spusť kontrolu uloženého kódu. Ručně můžeš ze složky cvičení spustit:

```sh
javac -encoding UTF-8 --release 21 -d out src/main/java/Main.java
java -cp out Main
```
