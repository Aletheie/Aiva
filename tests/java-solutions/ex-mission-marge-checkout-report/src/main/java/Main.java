import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    cash = new Cash(input.nextInt(), input.nextInt());
    printReceipt();
  }

  static void printReceipt() {
    // UPRAVUJ ODSUD
    int total = cash.total();
    int paid = cash.paid();
    System.out.println("Celkem: " + total);
    System.out.println("Zaplaceno: " + paid);
    if (paid < total) System.out.println("Doplatit: " + (total - paid));
    else System.out.println("Vratit: " + (paid - total));
    // UPRAVUJ POTUD
  }

  static Cash cash;

  static class Cash {
    private final int total, paid;

    Cash(int t, int p) {
      total = t;
      paid = p;
    }

    int total() {
      return total;
    }

    int paid() {
      return paid;
    }
  }
}
