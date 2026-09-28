import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    WaitingList queue = new WaitingList();
    int n = in.nextInt();
    for (int i = 0; i < n; i++) {
      String op = in.next();
      if (op.equals("ADD")) System.out.println(queue.add(in.next()));
      else if (op.equals("CANCEL")) System.out.println(queue.cancel(in.next()));
      else System.out.println(queue.next());
    }
    System.out.println("Cekaji: " + queue.snapshot());
  }
}

class WaitingList {
  // UPRAVUJ ODSUD
  private final List<String> names = new ArrayList<>();

  boolean add(String name) {
    names.add(name);
    return true;
  }

  boolean cancel(String name) {
    return names.remove(name);
  }

  String next() {
    return names.isEmpty() ? "-" : names.get(0);
  }

  List<String> snapshot() {
    return names;
  }
  // UPRAVUJ POTUD
}
