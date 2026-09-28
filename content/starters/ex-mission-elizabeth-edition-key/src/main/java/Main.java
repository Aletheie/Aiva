import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    String code = in.nextLine(), language = in.nextLine();
    Edition a = new Edition(code, language), b = new Edition(in.nextLine(), in.nextLine());
    Edition copy = new Edition(code, language);
    Set<Edition> set = new HashSet<>();
    set.add(a);
    set.add(b);
    System.out.println("Rovne: " + a.equals(b));
    System.out.println("Pocet: " + set.size());
    System.out.println("Kopie nalezena: " + set.contains(copy));
    System.out.println("Hash kopie: " + (a.hashCode() == copy.hashCode()));
  }
}

class Edition {
  // UPRAVUJ ODSUD
  private final String code, language;

  Edition(String code, String language) {
    this.code = code.trim();
    this.language = language.trim().toUpperCase(Locale.ROOT);
  }

  @Override
  public boolean equals(Object other) {
    return other instanceof Edition e && code.equals(e.code);
  }

  @Override
  public int hashCode() {
    return code.hashCode();
  }
  // UPRAVUJ POTUD
}
