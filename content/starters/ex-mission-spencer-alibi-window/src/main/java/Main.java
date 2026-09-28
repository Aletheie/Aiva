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
    int count = 0;
    for (int value : verified) if (value == 1) count++;
    System.out.println("Delka: " + count);
    System.out.println("Od: 0");
    System.out.println("Do: " + (count - 1));
    // UPRAVUJ POTUD
  }
}
