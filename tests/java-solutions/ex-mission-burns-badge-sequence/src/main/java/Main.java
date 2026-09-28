import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    int n = Integer.parseInt(in.nextLine());
    List<Badge> badges = new ArrayList<>();
    for (int i = 0; i < n; i++) {
      Badge b = Badge.issue(in.nextLine());
      if (b == null) System.out.println("ODMITNUTO");
      else badges.add(b);
    }
    for (Badge b : badges) System.out.println(b.id() + ":" + b.owner());
    System.out.println("Vydano: " + Badge.issued());
  }
}

class Badge {
  // UPRAVUJ ODSUD
  private static int issued;
  private final int id;
  private final String owner;

  private Badge(int id, String owner) {
    this.id = id;
    this.owner = owner;
  }

  static Badge issue(String text) {
    String owner = text.trim();
    if (owner.isEmpty()) return null;
    issued++;
    return new Badge(issued, owner);
  }

  static int issued() {
    return issued;
  }

  int id() {
    return id;
  }

  String owner() {
    return owner;
  }
  // UPRAVUJ POTUD
}
