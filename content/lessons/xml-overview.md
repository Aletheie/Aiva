## Strom elementů a atributů

Profil se jménem a číslem můžeme zapsat i pomocí značek. **XML (Extensible Markup Language)** má pro každou část dokumentu pojmenovaný element: v našem příkladu je uvnitř profilu jméno. S tímto formátem už ses setkala v `pom.xml`.

```xml
<profile id="7">
  <name>Ada</name>
</profile>
```

`profile` obaluje celý záznam, proto je kořenový **element**. Číslo 7 je v jeho **atributu** `id`, tedy údaji uvnitř otevírací značky. Jméno Ada najdeš mezi značkami vnořeného elementu `name`. Umístění tak ukazuje, ke kterému záznamu údaj patří. Značky se správně uzavírají a párují; `<name>` se liší od `<Name>`. Dokument má jeden kořen. Text `Ada & Eva` musí být v XML zapsán jako `Ada &amp; Eva`; `<` v textu jako `&lt;`. Tyto zápisy jsou **entity**. Parser převádí zápis na skutečné znaky.

## Čtení a zápis s API v JDK

**Parser** převede text na strukturu. Použijeme DOM, strom celého dokumentu v paměti. Pro tento příklad nepotřebuješ externí knihovnu. Celý `Main.java` vytvoří cvičný vstupní soubor, přečte ho a zapíše upravený do jiné cesty:

```java
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class Main {
    public static void main(String[] args) throws Exception {
        Path input = Path.of("profile-input.xml");
        Files.writeString(input, "<profile id=\"7\"><name>Ada</name></profile>",
                StandardCharsets.UTF_8);

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
        factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
        factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
        factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");
        factory.setXIncludeAware(false);
        factory.setExpandEntityReferences(false);
        Document document = factory.newDocumentBuilder().parse(input.toFile());
        Element root = document.getDocumentElement();
        if (!root.getTagName().equals("profile")) {
            throw new IllegalArgumentException("Očekávám profile");
        }
        if (root.getElementsByTagName("name").getLength() != 1) {
            throw new IllegalArgumentException("Očekávám právě jedno jméno");
        }
        String name = root.getElementsByTagName("name").item(0).getTextContent();
        System.out.println(root.getAttribute("id") + ": " + name); // 7: Ada
        root.setAttribute("active", "true");

        TransformerFactory output = TransformerFactory.newInstance();
        output.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
        output.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
        output.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");
        var transformer = output.newTransformer();
        transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        transformer.transform(new DOMSource(document),
                new StreamResult(Path.of("profile-output.xml").toFile()));
    }
}
```

`DocumentBuilderFactory.newInstance()` vybere dostupný parser. `newDocumentBuilder()` vytvoří čtečku a `parse(File)` načte dokument. `getDocumentElement()` vrátí kořen, `getTagName()` název značky. `getElementsByTagName("name")` hledá všechny potomky tohoto jména, nejen přímé děti; pro tento malý formát to stačí. `getLength()` kontroluje počet nalezených uzlů, `item(0)` vezme první a `getTextContent()` přečte text. Bez kontroly počtu by `item(0)` mohlo vrátit `null`.

`getAttribute("id")` vrátí text atributu, nebo prázdný text, pokud chybí. `setAttribute` atribut nastaví. Číselný význam `id` bys ještě ověřila převodem; XML samo nerozhoduje, jestli je sedm platným identifikátorem.

## Proč nastavujeme parser

XML může obsahovat `DOCTYPE`, definici typu dokumentu a vlastních entit. Externí entity by mohly odkazovat na soubor nebo síť; pro naše datové soubory je nepotřebujeme. `disallow-doctype-decl` deklaraci odmítne, prázdné `ACCESS_EXTERNAL_DTD` a `ACCESS_EXTERNAL_SCHEMA` zakazují externí přístupy. `FEATURE_SECURE_PROCESSING` zapne bezpečnostní omezení zpracování. `setXIncludeAware(false)` vypne vkládání dalších dokumentů a `setExpandEntityReferences(false)` rozbalování referencí entit. Vestavěné `&amp;` lze dál běžně číst.

Při nepodporovaném bezpečnostním nastavení ukázka skončí chybou; nesnaží se pokračovat bez něj. URI v `setFeature` je název vlastnosti, ne pokyn ke stažení webové stránky.

## Zápis a chyby

`TransformerFactory` vytváří převodník dokumentu na výstup. `newTransformer()` zde vytvoří převod bez vlastní transformační šablony. `setOutputProperty` nastaví kódování a odsazení. `DOMSource` obalí strom, `StreamResult` určí výstupní soubor a `transform` provede zápis. Knihovna správně escapuje text, takže XML neskládáme ručně konkatenací neověřených vstupů.

`var` odvodí typ `transformer` při překladu; není dynamický typ. `throws Exception` zde předává chyby parseru, vstupu i převodníku ven z výukového `main`, aby bylo vidět jejich přesné místo. V aplikaci by je například metoda pro otevření profilu zachytila a zobrazila důvod, proč profil nešlo načíst, stejně jako u [souborů](lesson:files-overview).

Výstup je jiný soubor, takže zůstává vidět rozdíl po přidání `active="true"`. Pro experiment s neplatným XML nejprve vynech úvodní `writeString`, které jinak vstup znovu vytvoří. Vyzkoušej chybějící `name`, nepárovou značku a text s `&amp;`. DOM drží dokument celý v paměti; velmi velké dokumenty vyžadují jiný způsob průběžného čtení.
