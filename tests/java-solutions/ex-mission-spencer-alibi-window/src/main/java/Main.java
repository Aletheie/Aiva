import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int n = input.nextInt();
    int[] values = new int[n];
    for (int i = 0; i < n; i++) values[i] = input.nextInt();
    longest(values);
  }

  static void longest(int[] verified) {
    // UPRAVUJ ODSUD
    int current = 0, start = 0, best = 0, bestStart = -1;
    for (int i = 0; i < verified.length; i++) {
      if (verified[i] == 0) {
        current = 0;
        continue;
      }
      if (current == 0) start = i;
      current++;
      if (current > best) {
        best = current;
        bestStart = start;
      }
    }
    int end = best == 0 ? -1 : bestStart + best - 1;
    System.out.println("Delka: " + best);
    System.out.println("Od: " + bestStart);
    System.out.println("Do: " + end);
    // UPRAVUJ POTUD
  }
}
