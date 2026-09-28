import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int hours = input.nextInt(), lockers = input.nextInt();
    System.out.println(fee(hours, lockers));
  }

  static int fee(int hours, int lockers) {
    // UPRAVUJ ODSUD
    int blocks = (hours + 2) / 3;
    return blocks * 25 * lockers;
    // UPRAVUJ POTUD
  }
}
