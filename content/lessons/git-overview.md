## Pracovní složka, staging a historie

Zkusíš jiný výpočet dopravy a později chceš zjistit, co přesně se změnilo. **Git** uchovává verze souborů a jejich historii v **repozitáři (repository)**. Pracuješ přitom se třemi místy:

- **Pracovní strom (working tree):** soubory, které právě upravuješ.
- **Staging area (index):** změny vybrané pro další záznam, třeba opravený výpočet a jeho test.
- **Commit:** uložený snímek vybraných změn se zprávou a vazbou na historii.

Uložení souboru v editoru tedy ještě nevytvoří commit. Ani commit sám nic neodešle na server.

GitHub a GitLab jsou služby pro vzdálené repozitáře a spolupráci. Git lze používat lokálně bez nich. Dostupnost klienta ověříš `git --version`.

## První malý repozitář

Následující příkazy spouštěj v nové cvičné složce. `mkdir` vytváří adresář a `cd` do něj přepíná; jsou to příkazy shellu, ne Gitu.

```sh
mkdir java-git-practice
cd java-git-practice
git init -b main
git config user.name "Studentka kurzu"
git config user.email "student@example.test"
```

`init -b main` vytvoří repozitář s počáteční větví `main`. `config` zde nastavuje jméno a e-mail jen pro tento repozitář; u skutečné týmové práce použij vlastní zvolené údaje. V editoru vytvoř `README.md` s jedním řádkem `Kurz Java`.

```sh
git status
git add README.md
git diff --staged
git commit -m "Přidání popisu projektu"
git log --oneline
```

`status` ukáže nové, změněné a připravené soubory. `add README.md` připraví aktuální obsah jednoho souboru. `diff --staged` ukazuje, co přesně vstoupí do commitu. `commit -m` vytvoří commit s uvedenou zprávou. `log --oneline` stručně vypíše historii s identifikátory commitů.

Když po `add` znovu upravíš soubor, další změna ještě ve stagingu není. `git diff` porovná pracovní změny proti stagingu, `git diff --staged` staging proti poslednímu commitu. Můžeš tak například uložit hotovou opravu výpočtu, zatímco rozepsaná úprava menu zůstane jen v pracovním stromu.

## Větev jako oddělený směr práce

**Větev (branch)** je pojmenovaný ukazatel v historii; nekopíruje celý projekt do jiné složky. `HEAD` označuje aktuálně vybraný bod, obvykle přes větev.

```sh
git switch -c feature/readme
```

`switch -c` vytvoří a vybere novou větev. Přidej do README řádek `Spuštění: mvn test`, připrav soubor a commitni:

```sh
git add README.md
git commit -m "Doplnění příkazu pro testy"
git switch main
git merge feature/readme
git branch
```

`switch main` přepne větev, `merge` začlení historii z uvedené větve do **aktuální** větve. Pokud se `main` mezitím nezměnila, může jít o fast-forward: pouze se posune ukazatel. Jinak Git obvykle vytvoří slučovací commit. `branch` bez argumentů vypíše lokální větve a označí aktuální.

## Nacvič skutečný konflikt

Konflikt není selhání celého repozitáře; Git potřebuje rozhodnutí o překrývajících se změnách. Z hlavní větve vytvoř `git switch -c alternate-title`, změň první řádek README na `Java tým A` a commitni. Přepni na `main`, stejný původní řádek změň na `Java tým B` a také commitni. Pak spusť `git merge alternate-title`.

V README uvidíš přibližně:

```text
<<<<<<< HEAD
Java tým B
=======
Java tým A
>>>>>>> alternate-title
```

Horní část je aktuální větev, dolní připojovaná. Nahraď celý úsek dohodnutým textem `Java tým`, odstraň všechny tři značky a zkontroluj celý soubor. `git add README.md` označí konflikt jako vyřešený a `git commit -m "Sjednocení názvu týmu"` sloučení dokončí. U kódu před dokončením spusť testy.

Pokud chceš nedokončené sloučení opustit, `git merge --abort` se pokusí obnovit stav před zahájením. Proto do merge vstupuj s čistým pracovním stromem; rozpracované nesouvisející změny nejdřív ulož vhodným commitem.

## Vzdálený repozitář

`git clone URL` stáhne existující repozitář včetně historie a nastaví vzdálený název `origin`. Pro svůj nový lokální projekt použij `git remote add origin URL`, kde URL nahradíš adresou vlastního prázdného repozitáře. `git remote -v` vypíše adresy.

`git push -u origin main` odešle větev a nastaví sledovaný protějšek pro další push/pull. `git fetch origin` stáhne novou vzdálenou historii bez změny tvých pracovních souborů. `git pull --ff-only` ji navíc začlení, ale jen pokud není potřeba slučovat odlišné historie; při rozchodu zastaví a nechá tě rozhodnout. Push odmítnutý kvůli cizím změnám řeš načtením a kontrolou historie, ne automatickým force-push.

## Co verzovat a jak opravit omyl

Vytvoř `.gitignore` s řádky `target/`, `build/` a `.env`. První dvě položky jsou build výstup, třetí místní konfigurace, která může obsahovat tajné údaje. Ignore neodstraní soubor již sledovaný Gitem ani tajemství z historie.

`git restore --staged README.md` vyřadí změnu ze stagingu, ale nechá úpravu na disku. `git restore README.md` naopak zahodí necommitnuté pracovní změny daného souboru; používej ho jen po ověření diffu. `git revert ID` vytvoří nový commit s opačnou změnou již uloženého commitu, což zachovává sdílenou historii. Před každou opravou si řekni, kterou ze tří vrstev chceš změnit.

> [!OPTIONAL] Pod povrch: commit a větev
>
> Commit odkazuje na strom uložených souborů, metadata a rodičovské commity. Identifikátor se odvozuje od obsahu, proto změna commit zprávy nebo rodiče vytváří jiný commit. Git umí sdílet nezměněné objekty mezi snímky; nejde o prosté kopírování celé složky pro každou verzi.
>
> Větev je pohyblivé jméno ukazující na commit. Dvě větve mohou ukazovat na stejný bod a začnou se lišit až dalšími změnami. Merge pracuje s historií a společným předkem, ne jen s tím, který soubor má novější čas uložení. I když se obě verze přeloží, musíš při konfliktu rozhodnout, jak se má spojený kód chovat.
