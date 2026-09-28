import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int batteries = input.nextInt(), size = input.nextInt();
    // UPRAVUJ ODSUD
    int kits = batteries / size;
    int left = batteries / size;
    int missing = left;
    System.out.println("Sady: " + kits);
    System.out.println("Zbyva: " + left);
    System.out.println("Doplnit: " + missing);
    // UPRAVUJ POTUD

  }
}
