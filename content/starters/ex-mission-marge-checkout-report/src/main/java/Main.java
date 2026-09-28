import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    cash = new Cash(input.nextInt(), input.nextInt());
    printReceipt();
  }

  static void printReceipt() {
    // UPRAVUJ ODSUD
    System.out.println("Celkem: " + cash.total());
    System.out.println("Zaplaceno: " + cash.paid());
    System.out.println("Vratit: " + (cash.total() - cash.paid()));
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
