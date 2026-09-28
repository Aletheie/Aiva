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
    for (int day = 0; day <= days; day++) {
      stock += delivery - demand;
      sentTotal += demand;
    }
    System.out.println("Zasoba: " + stock);
    System.out.println("Vydano: " + sentTotal);
    System.out.println("Odlozeno: " + overflow);
    // UPRAVUJ POTUD

  }
}
