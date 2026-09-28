import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int n = input.nextInt(), from = input.nextInt(), to = input.nextInt(), amount = input.nextInt();
    int[] stock = new int[n];
    for (int i = 0; i < n; i++) stock[i] = input.nextInt();
    int[] result = preview(stock, from, to, amount);
    System.out.println("Puvodni: " + Arrays.toString(stock));
    System.out.println("Nahled: " + Arrays.toString(result));
    System.out.println("Stejne pole: " + (stock == result));
  }

  static int[] preview(int[] stock, int from, int to, int amount) {
    // UPRAVUJ ODSUD
    int[] copy = stock.clone();
    if (from == to || stock[from] < amount) return copy;
    copy[from] -= amount;
    copy[to] += amount;
    return copy;
    // UPRAVUJ POTUD
  }
}
