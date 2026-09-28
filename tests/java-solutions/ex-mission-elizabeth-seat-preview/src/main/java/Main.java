import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int n = input.nextInt(), group = input.nextInt();
    boolean[] seats = new boolean[n];
    for (int i = 0; i < n; i++) seats[i] = input.nextInt() == 1;
    boolean[] result = preview(seats, group);
    System.out.println("Puvodni: " + Arrays.toString(seats));
    System.out.println("Nahled: " + Arrays.toString(result));
    System.out.println("Stejne pole: " + (seats == result));
  }

  static boolean[] preview(boolean[] occupied, int group) {
    // UPRAVUJ ODSUD
    boolean[] copy = occupied.clone();
    int free = 0;
    for (int i = 0; i < occupied.length; i++) {
      free = occupied[i] ? 0 : free + 1;
      if (free == group) {
        for (int j = i - group + 1; j <= i; j++) copy[j] = true;
        break;
      }
    }
    return copy;
    // UPRAVUJ POTUD
  }
}
