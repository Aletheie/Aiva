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
    boolean[] copy = occupied;
    int reserved = 0;
    for (int i = 0; i < copy.length && reserved < group; i++) {
      if (!copy[i]) {
        copy[i] = true;
        reserved++;
      }
    }
    return copy;
    // UPRAVUJ POTUD
  }
}
