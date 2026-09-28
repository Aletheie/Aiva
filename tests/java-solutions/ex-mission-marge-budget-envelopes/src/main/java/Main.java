import java.util.*;

public class Main {
  public static void main(String[] args) {
    Scanner input = new Scanner(System.in);
    Envelope first = new Envelope(input.nextInt()), second = new Envelope(input.nextInt());
    System.out.println(first.spend(input.nextInt()));
    System.out.println(first.spend(input.nextInt()));
    System.out.println("Prvni: " + first.balance());
    System.out.println("Druha: " + second.balance());
  }
}

class Envelope {
  // UPRAVUJ ODSUD
  private int amount;

  Envelope(int initial) {
    this.amount = initial;
  }

  boolean spend(int value) {
    if (value <= 0 || value > amount) return false;
    amount -= value;
    return true;
  }

  int balance() {
    return amount;
  }
  // UPRAVUJ POTUD
}
