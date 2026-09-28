## Vyber typ podle významu

Narozeniny jsou datum, začátek promítání čas v určitém místě a záznam o odeslání zprávy konkrétní okamžik. Jeden text nebo počet milisekund nevystihne všechna tato pravidla. Balíček java.time nabízí typy podle toho, co údaj znamená.

| Typ | Kdy se hodí |
|---|---|
| LocalDate | Datum bez času a pásma, například termín vrácení knihy |
| LocalTime | Místní čas bez data |
| LocalDateTime | Datum a čas bez určeného pásma |
| Instant | Konkrétní okamžik na časové ose |
| ZonedDateTime | Datum a čas v pojmenovaném pásmu |
| Duration | Časový úsek v sekundách a jejich zlomcích |
| Period | Kalendářní počet let, měsíců a dnů |

## Kalendář počítá za tebe

Celý soubor `Main.java`:

```java
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class Main {
    public static void main(String[] args) {
        LocalDate borrowed = LocalDate.parse("2024-02-28");
        LocalDate due = borrowed.plusDays(2);
        System.out.println(due); // 2024-03-01
        System.out.println(ChronoUnit.DAYS.between(borrowed, due)); // 2
    }
}
```

Knihu jsme půjčili 28. února 2024 na dva dny. Protože je rok přestupný, prvním dnem navíc je 29. únor a druhým 1. březen. `parse` přečte datum ve standardním ISO zápisu a neexistující datum odmítne. `plusDays` vrátí nový termín; původní `borrowed` zůstává 28. února. `ChronoUnit.DAYS.between` spočítá celkový počet dnů mezi oběma daty a při obráceném pořadí může vrátit záporné číslo. Nepočítej rozdíl odečtením čísel dnů v měsíci. Ani `Period.between(...).getDays()` není obecně celkový počet dnů: vrací jen denní složku období po oddělení let a měsíců.

## Formát data pro zobrazení a ukládání

Pro český výpis můžeš použít `DateTimeFormatter.ofPattern("d. M. uuuu")` a `due.format(formatter)`, s importem java.time.format.DateTimeFormatter. Vzor uuuu značí rok. Velké MM jsou měsíc, malé mm minuty. Pokud vlastní formát také parsuješ a chceš odmítat neplatná data, nastav `withResolverStyle(ResolverStyle.STRICT)`; výchozí chytré řešení některé neplatné kombinace upravuje.

Datum ukládej a předávej v jednotném formátu ISO. Do podoby určené čtenáři ho převeď až při zobrazení. Chybu uživatelského data zachyť jako DateTimeParseException a vysvětli požadovaný formát, místo automatického dosazení dnešního data.

## Den není vždy dvacet čtyři hodin

LocalDate nemá pásmo, a proto nemůže určit přesný okamžik. `ZoneId.of("Europe/Prague")` popisuje pravidla pásma včetně změn času. Kalendářní posun o jeden den v takovém pásmu může překlenout jiný počet hodin než Duration.ofHours(24). Pro pravidelnou schůzku v devět ráno chceš zpravidla zachovat místní hodinu. U záznamu „zpráva odeslána“ potřebuješ stejný okamžik, i když si ho příjemce v jiném pásmu zobrazí jinou hodinou.

## Hodiny jsou také vstup

Volání now závisí na čase spuštění a pásmu počítače. Metoda s termínem je lépe ověřitelná, když dnešek dostane jako parametr. Rozsáhlejší aplikace mohou předat Clock; `Clock.fixed` vytvoří hodiny s pevným okamžikem. Neměň kvůli testu systémové datum.

Procvič přestupný únor, přelom roku, dnešní termín a zpoždění. V lekci řešíme kalendářní dny, takže pro tato pravidla nepotřebujeme ani časové pásmo, ani historické opravy kalendáře.
