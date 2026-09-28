import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int n = input.nextInt(), capacity = input.nextInt();
    int[] weights = new int[n];
    for (int i = 0; i < n; i++) weights[i] = input.nextInt();
    LoadReport r = loadPrefix(weights, capacity);
    System.out.println("Nalozeno: " + r.loaded());
    System.out.println("Hmotnost: " + r.weight());
    System.out.println("Stop: " + r.stoppedAt());
  }

  static LoadReport loadPrefix(int[] weights, int capacity) {
    // UPRAVUJ ODSUD
    int loaded = 0, total = 0;
    for (int i = 0; i < weights.length; i++) {
      if (total + weights[i] > capacity) return new LoadReport(loaded, total, i);
      total += weights[i];
      loaded++;
    }
    return new LoadReport(loaded, total, -1);
    // UPRAVUJ POTUD
  }

  record LoadReport(int loaded, int weight, int stoppedAt) {}
}
