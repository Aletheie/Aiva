import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    CaseFile source = new CaseFile();
    source.label = input.nextLine();
    source.verified = Boolean.parseBoolean(input.nextLine());
    String label = input.nextLine();
    CaseFile copy = duplicate(source, label);
    copy.verified = !copy.verified;
    System.out.println("Original: " + source.label + "/" + source.verified);
    System.out.println("Kopie: " + copy.label + "/" + copy.verified);
    System.out.println("Stejny objekt: " + (source == copy));
  }

  static CaseFile duplicate(CaseFile source, String label) {
    // UPRAVUJ ODSUD
    CaseFile copy = source;
    copy.label = label;
    return copy;
    // UPRAVUJ POTUD
  }

  static class CaseFile {
    String label;
    boolean verified;
  }
}
