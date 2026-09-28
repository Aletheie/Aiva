import java.util.*;

public class Main {
  public static void main(String[] args) {
    Scanner in = new Scanner(System.in);
    Crate crate = new Crate(in.nextInt(), in.nextInt());
    int n = in.nextInt();
    for (int i = 0; i < n; i++) {
      String action = in.next();
      int amount = in.nextInt();
      boolean result = action.equals("TAKE") ? crate.take(amount) : crate.add(amount);
      System.out.println(result + ":" + crate.amount());
    }
    System.out.println("Konec: " + crate.amount());
  }
}

class Crate {
  // UPRAVUJ ODSUD
  private final int capacity;
  private int stock;

  Crate(int capacity, int initial) {
    this.capacity = capacity;
    stock = initial;
  }

  boolean take(int n) {
    if (n <= 0 || n > stock) return false;
    stock -= n;
    return true;
  }

  boolean add(int n) {
    if (n <= 0 || n > capacity - stock) return false;
    stock += n;
    return true;
  }

  int amount() {
    return stock;
  }
  // UPRAVUJ POTUD
}
