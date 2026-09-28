import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int n = input.nextInt(), limit = input.nextInt();
    int[] stock = new int[n];
    for (int i = 0; i < n; i++) stock[i] = input.nextInt();
    audit(stock, limit);
  }

  static void audit(int[] stock, int limit) {
    // UPRAVUJ ODSUD
    int total = 0, low = 0, minIndex = 0;
    for (int i = 0; i < stock.length - 1; i++) {
      total += stock[i];
      if (stock[i] <= limit) low++;
      if (stock[i] <= stock[minIndex]) minIndex = i;
    }
    System.out.println("Celkem: " + total);
    System.out.println("Pod limitem: " + low);
    System.out.println("Nejnizsi index: " + minIndex);
    // UPRAVUJ POTUD
  }
}
