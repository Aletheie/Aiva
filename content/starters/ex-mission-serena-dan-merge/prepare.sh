#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if [ -e merge-lab ]; then printf '%s\n' 'Složka merge-lab už existuje. Příprava ji nepřepíše.' >&2; exit 1; fi
mkdir merge-lab
cd merge-lab
git init -b main
git config user.name 'AIVA Practice'
git config user.email 'practice@example.invalid'
git config commit.gpgsign false
git config core.hooksPath /dev/null
printf '%s\n' '*.class' > .gitignore
cat > Newsletter.java <<'JAVA'
public class Newsletter {
 public static String subject(String title){
  return "News: " + title;
 }
}
JAVA
cp ../Check.java Check.java
git add .gitignore Newsletter.java Check.java
git commit -m 'Priprav kostru newsletteru'
git switch -c serena-edit
cat > Newsletter.java <<'JAVA'
public class Newsletter {
 public static String subject(String title){
  return "Upper East Side | " + title.trim();
 }
}
JAVA
git add Newsletter.java
git commit -m 'Serena upravuje znacku a okraje titulku'
git switch main
cat > Newsletter.java <<'JAVA'
public class Newsletter {
 public static String subject(String title){
  return "News: " + (title.isBlank() ? "(bez titulku)" : title);
 }
}
JAVA
git add Newsletter.java
git commit -m 'Dan resi prazdny titulek'
printf '%s\n' 'Připraveno. Pokračuj: cd merge-lab a git merge serena-edit'
