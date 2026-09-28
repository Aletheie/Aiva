import java.util.*;
import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.*;
import org.xml.sax.InputSource;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    String xml = in.nextLine();
    try {
      Participant p = ParticipantMapper.read(SafeXml.read(xml));
      System.out.println(p.id() + ":" + p.name() + ":" + (p.present() ? "PRITOMEN" : "NEPRITOMEN"));
    } catch (IllegalArgumentException e) {
      System.out.println("NEPLATNY ZAZNAM");
    } catch (org.xml.sax.SAXException e) {
      System.out.println("NEPLATNE XML");
    }
  }
}

record Participant(String id, String name, boolean present) {}

class Children {
  static List<Element> named(Element root, String name) {
    List<Element> result = new ArrayList<>();
    NodeList nodes = root.getChildNodes();
    for (int i = 0; i < nodes.getLength(); i++)
      if (nodes.item(i) instanceof Element e && e.getTagName().equals(name)) result.add(e);
    return result;
  }
}

class SafeXml {
  static Document read(String xml) throws Exception {
    DocumentBuilderFactory f = DocumentBuilderFactory.newInstance();
    f.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
    f.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
    f.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
    f.setAttribute(XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");
    f.setXIncludeAware(false);
    f.setExpandEntityReferences(false);
    var builder = f.newDocumentBuilder();
    builder.setErrorHandler(
        new org.xml.sax.helpers.DefaultHandler() {
          @Override
          public void error(org.xml.sax.SAXParseException e) throws org.xml.sax.SAXException {
            throw e;
          }

          @Override
          public void fatalError(org.xml.sax.SAXParseException e) throws org.xml.sax.SAXException {
            throw e;
          }
        });
    return builder.parse(new InputSource(new java.io.StringReader(xml)));
  }
}

class ParticipantMapper {
  // UPRAVUJ ODSUD
  static Participant read(Document doc) {
    Element root = doc.getDocumentElement();
    String name = root.getElementsByTagName("name").item(0).getTextContent();
    String present = root.getElementsByTagName("present").item(0).getTextContent();
    return new Participant(root.getAttribute("id"), name, Boolean.parseBoolean(present));
  }
  // UPRAVUJ POTUD
}
