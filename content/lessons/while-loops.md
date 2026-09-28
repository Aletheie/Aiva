## Dokud zbývá práce

Claire chystá tři balíčky zásob pro evakuační tým. Než začne další, zkontroluje, jestli ještě nějaký zbývá. Cyklus `while` dělá totéž: ověří podmínku **před každým průchodem**. Počet zbývajících balíčků zde představuje `remaining`:

```java
int remaining = 3;
while (remaining > 0) {
    System.out.println(remaining);
    remaining = remaining - 1;
}
```

Vypíše 3, 2 a 1. Pokud by `remaining` začalo na nule, tělo by se neprovedlo ani jednou.

## Něco se musí změnit

Pokud po dokončení balíčku neodečteš jedničku, v evidenci pořád zbývají tři. Program se znovu ptá na stejnou pravdivou podmínku a nikdy neskončí. Tomu se říká **nekonečný cyklus (infinite loop)**. Běh zastav a zkontroluj řádek, který má počet zmenšovat.

Příkaz `break;` ukončí nejbližší cyklus hned. Hodí se například po uhodnutí čísla:

```java
while (input.hasNextLine()) {
    int guess = Integer.parseInt(input.nextLine());
    if (guess == 7) {
        System.out.println("Uhodnuto");
        break;
    }
}
```

`input` je připravený Scanner. `hasNextLine()` ověří, jestli lze přečíst další řádek. Při ručním zadávání může čekat na vstup.

## Když nevíš počet opakování

Platební automat neví, kolik mincí dostane. Stačí mu číst další platbu, dokud součet nedosáhne ceny lístku. Ve cvičení doplníš právě takový postup a vrácení přeplatku. Pak můžeš zkusit projekt **Wednesday a tajný kód**.

Základ opakování jsme si ukázali na [cyklu for](lesson:loops). U `while` budeme jednotlivé kroky řídit sami.

## do-while provede tělo alespoň jednou

Pokud chceš nejdřív ukázat menu a až potom rozhodovat o opakování, hodí se `do-while`. Úryvek do `main`:

```java
int attempts = 0;
do {
    attempts++;
    System.out.println("Pokus " + attempts);
} while (attempts < 2);
```

Výstup je Pokus 1 a Pokus 2. Podmínka se kontroluje až za tělem a za uzavírací závorkou je zde středník. I kdyby byla podmínka od začátku false, první průchod už proběhl.

## break a continue mají jiný účel

`break` ukončí nejbližší cyklus. `continue` přeskočí zbytek aktuálního průchodu a pokračuje další kontrolou; u `for` ještě proběhne aktualizace v záhlaví. V `while` musíš změnu čítače ohlídat sama:

```java
int number = 0;
while (number < 5) {
    number++;
    if (number == 3) {
        continue;
    }
    System.out.println(number);
}
```

Vypíšou se 1, 2, 4 a 5. Zvýšení proběhne před případným `continue`, takže se program nezasekne na trojce. Ve vnořených cyklech `break` bez dalšího označení neukončuje všechny úrovně najednou.

## Náhodné číslo pro hru

Projekt Wednesday a tajný kód využívá `Random`. Přidej `import java.util.Random;` nad třídu a do `main`:

```java
Random random = new Random();
int secret = random.nextInt(100) + 1;
System.out.println(secret);
```

`new Random()` vytvoří generátor pseudonáhodných hodnot. `nextInt(100)` vrací celé číslo od 0 včetně do 100 bez něj. Přičtením jedné získáme rozsah 1–100. Náhodný výběr může hodnotu opakovat; neznamená „pokaždé jinak“. Pro ladění nejdřív použij pevné tajné číslo 42, aby šlo pokusy zopakovat.

Ve hře musí každá větev buď přečíst další vstup, změnit stav, nebo skončit. Ověř správný tip hned napoprvé, několik špatných tipů i ukončovací příkaz. Při očekávaných nečíselných vstupech přidej [ošetření převodu](lesson:exceptions-overview).
