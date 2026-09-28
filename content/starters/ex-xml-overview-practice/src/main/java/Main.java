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
