import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    String x = in.nextLine(), y = in.nextLine();
    Invitation a = new Invitation(x), b = new Invitation(y);
    Set<Invitation> set = new HashSet<>();
    set.add(a);
    set.add(b);
    System.out.println("Rovne: " + a.equals(b));
    System.out.println("Pocet: " + set.size());
    System.out.println("Kopie nalezena: " + set.contains(new Invitation(x)));
    System.out.println("Rovno textu: " + a.equals(x));
  }
}

class Invitation {
  // UPRAVUJ ODSUD
  private final String code;

  Invitation(String code) {
    this.code = code.trim().toUpperCase(Locale.ROOT);
  }

  @Override
  public boolean equals(Object other) {
    return other instanceof Invitation i && code == i.code;
  }

  @Override
  public int hashCode() {
    return System.identityHashCode(this);
  }
  // UPRAVUJ POTUD
}
