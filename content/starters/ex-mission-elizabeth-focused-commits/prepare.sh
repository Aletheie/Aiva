#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if [ -e staging-lab ]; then printf '%s\n' 'Složka staging-lab už existuje. Příprava ji nepřepíše.' >&2; exit 1; fi
mkdir staging-lab
cd staging-lab
git init -b main
git config user.name 'AIVA Practice'
git config user.email 'practice@example.invalid'
git config commit.gpgsign false
git config core.hooksPath /dev/null
cat > catalog.csv <<'DATA'
title,author
Pride and Prejudce,Jane Austen
Jane Eyre,Charlotte Bronte
DATA
printf '%s\n' '# Katalog' '' 'Otevři catalog.csv.' > README.md
git add catalog.csv README.md
git commit -m 'Pridej vychozi katalog'
cat > catalog.csv <<'DATA'
title,author
Pride and Prejudice,Jane Austen
Jane Eyre,Charlotte Bronte
DATA
git add catalog.csv
cat >> catalog.csv <<'DATA'
Little Women,Louisa May Alcott
DATA
printf '%s\n' '# Katalog' '' 'Otevři catalog.csv.' '' 'Sloupce: title,author; každý další řádek je jedna kniha.' > README.md
printf '%s\n' 'SOUKROME POZNAMKY: návrhy dalších knih, zatím nepublikovat.' > notes.private.txt
printf '%s\n' 'Připraveno: oprava je staged; nová kniha, README a soukromé poznámky nejsou.'
