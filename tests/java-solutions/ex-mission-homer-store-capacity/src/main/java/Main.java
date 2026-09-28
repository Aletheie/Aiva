import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int days = input.nextInt(),
        capacity = input.nextInt(),
        stock = input.nextInt(),
        delivery = input.nextInt(),
        demand = input.nextInt();
    // UPRAVUJ ODSUD
    int sentTotal = 0, overflow = 0;
    for (int day = 0; day < days; day++) {
      stock += delivery;
      if (stock > capacity) {
        overflow += stock - capacity;
        stock = capacity;
      }
      int sent = Math.min(stock, demand);
      stock -= sent;
      sentTotal += sent;
    }
    System.out.println("Zasoba: " + stock);
    System.out.println("Vydano: " + sentTotal);
    System.out.println("Odlozeno: " + overflow);
    // UPRAVUJ POTUD

  }
}
