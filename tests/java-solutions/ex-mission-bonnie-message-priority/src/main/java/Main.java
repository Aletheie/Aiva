import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    Priority p = Priority.valueOf(in.next());
    int start = in.nextInt();
    int due = start + p.delay();
    System.out.println("Druh: " + p.label());
    System.out.println("Den: " + due / 1440);
    System.out.println("Minuta: " + due % 1440);
  }
}

// UPRAVUJ ODSUD
enum Priority {
  LOW("Odlozena", 120),
  NORMAL("Bezna", 30),
  URGENT("Nalehava", 5),
  IMMEDIATE("Okamzita", 0);
  private final String label;
  private final int delay;

  Priority(String label, int delay) {
    this.label = label;
    this.delay = delay;
  }

  String label() {
    return label;
  }

  int delay() {
    return delay;
  }
}
// UPRAVUJ POTUD
