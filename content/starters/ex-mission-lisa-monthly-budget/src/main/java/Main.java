import java.util.*;

public class Main {
  public static void main(String[] args) {
    Scanner in = new Scanner(System.in);
    Budget b = new Budget(in.nextInt(), in.nextInt());
    int n = in.nextInt();
    for (int i = 0; i < n; i++) {
      String op = in.next();
      if (op.equals("SPEND")) System.out.println("Platba: " + b.spend(in.nextInt()));
      else if (op.equals("CREDIT")) b.credit(in.nextInt());
      else b.newPeriod();
      System.out.println(b.balance() + ":" + b.used());
    }
  }
}

class Budget {
  // UPRAVUJ ODSUD
  private int balance, used;
  private final int limit;

  Budget(int balance, int limit) {
    this.balance = balance;
    this.limit = limit;
  }

  boolean spend(int n) {
    used += n;
    if (n > balance) return false;
    balance -= n;
    return true;
  }

  void credit(int n) {
    balance += n;
    used = 0;
  }

  void newPeriod() {
    balance = 0;
    used = 0;
  }

  int balance() {
    return balance;
  }

  int used() {
    return used;
  }
  // UPRAVUJ POTUD
}
