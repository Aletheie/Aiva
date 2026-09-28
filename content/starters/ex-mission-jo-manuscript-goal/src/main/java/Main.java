import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int goal = input.nextInt();
    // UPRAVUJ ODSUD
    int pages = 0, parts = 0;
    while (pages <= goal) {
      int added = input.nextInt();
      pages = added;
      parts++;
    }
    System.out.println("Strany: " + pages);
    System.out.println("Casti: " + parts);
    System.out.println("Hotovo: " + (pages >= goal));
    // UPRAVUJ POTUD

  }
}
