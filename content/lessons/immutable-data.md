## Final nezakazuje změnu obsahu seznamu

V pondělí si uložíš plán četby s Emmou. V úterý do pracovního seznamu přidáš Jane Eyre. Pondělní plán má přesto zachovat původní výběr, abys poznala, co se změnilo. Samotné `final` to nezařídí: zakáže proměnné přiřadit jiný seznam, ale položky v jejím `ArrayList` lze dál měnit. Ani `record` sám nezkopíruje objekty, které mu předáš.

**Neměnnost (immutability)** znamená, že stav objektu po vytvoření neměníme. Novou verzi vyjádříme novým objektem. Pokud má být celý plán neměnný, musí zůstat beze změny i jeho seznam knih.

## Ulož kopii seznamu

Celý soubor `Main.java`:

```java
import java.util.ArrayList;
import java.util.List;

public class Main {
    record ReadingPlan(List<String> titles) {
        ReadingPlan {
            titles = List.copyOf(titles);
        }
    }

    public static void main(String[] args) {
        List<String> draft = new ArrayList<>(List.of("Emma"));
        ReadingPlan saved = new ReadingPlan(draft);
        draft.add("Jane Eyre");
        System.out.println(saved.titles()); // [Emma]
        System.out.println(draft); // [Emma, Jane Eyre]
    }
}
```

Kompaktní konstruktor před uložením komponenty nahradí parametr neměnitelnou kopií. List.copyOf zachovává pořadí i duplicity, nepřijímá null seznam ani null prvky a vrací seznam, jehož strukturu volající nemůže upravit. Metoda někdy může vrátit už existující vhodný neměnitelný seznam. Spoléhej proto na slíbené chování: pozdější úprava `draft` nesmí změnit uložený plán.

## Pohled a kopie mají jiný význam

`Collections.unmodifiableList(draft)` zabraňuje změnám přes vrácený pohled. Když ale někdo upraví draft, pohled změnu uvidí. `new ArrayList<>(draft)` vytvoří samostatný seznam, který můžeš měnit. `List.copyOf(draft)` vytvoří kopii, do které už nelze přidávat ani z ní odebírat. V obou případech se kopíruje seznam, nikoli objekty v něm. Rozhodni se podle toho, zda má výsledek sledovat změny původního seznamu a zda ho chceš sama upravovat.

Všechny uvedené kopie jsou mělké. Kdyby seznam obsahoval měnitelné objekty Book, kopie by stále sdílela jejich reference. Změna názvu jedné takové knihy by byla vidět i v kopii seznamu. V našem příkladu jsou prvky String, které samy nemění svůj obsah, proto jedna úroveň kopírování stačí.

## Při změně vytvoř další hodnotu

Záznam `record Point(int x, int y)` se posune například vytvořením `new Point(old.x() + 1, old.y())`. Původní bod se nezmění. To usnadňuje testy: lze porovnat starý a nový stav, aniž by se očekávání přepsalo pod rukama.

Neměnnost však není důvod kopírovat velké kolekce po každém přečtení bez rozmyslu. V našem plánu stačí seznam zkopírovat při vytváření v konstruktoru. Metoda `titles()` pak může vracet tentýž neměnitelný seznam, aniž by ho při každém čtení znovu kopírovala. U citlivých dat dávej pozor i na automatický toString záznamu, který může zveřejnit všechny komponenty.

Ověř dvě nezávislé vlastnosti: změna vstupního seznamu neovlivní snímek a přes accessor nelze měnit strukturu snímku. Samotný úspěšný první výpis neprokazuje ani jednu z nich. Princip sdílení odkazů připomíná [předávání hodnotou](lesson:pass-by-value).
