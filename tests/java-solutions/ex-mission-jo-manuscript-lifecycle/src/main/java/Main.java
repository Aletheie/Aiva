import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    Manuscript m = new Manuscript();
    int n = in.nextInt();
    for (int i = 0; i < n; i++) {
      String op = in.next();
      boolean ok =
          op.equals("ADD") ? m.add(in.nextInt()) : op.equals("SUBMIT") ? m.submit() : m.withdraw();
      System.out.println(ok + ":" + m.pages() + "/" + m.version() + "/" + m.submitted());
    }
  }
}

class Manuscript {
  // UPRAVUJ ODSUD
  private int pages, version;
  private boolean submitted;

  boolean add(int n) {
    if (n <= 0 || submitted) return false;
    pages += n;
    version++;
    return true;
  }

  boolean submit() {
    if (pages == 0 || submitted) return false;
    submitted = true;
    return true;
  }

  boolean withdraw() {
    if (!submitted) return false;
    submitted = false;
    return true;
  }

  int pages() {
    return pages;
  }

  int version() {
    return version;
  }

  boolean submitted() {
    return submitted;
  }
  // UPRAVUJ POTUD
}
