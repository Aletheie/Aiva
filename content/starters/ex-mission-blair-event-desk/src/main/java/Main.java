import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    String type = input.nextLine().trim().toUpperCase(Locale.ROOT);
    int plus = input.nextInt();
    // UPRAVUJ ODSUD
    switch (type) {
      case "VIP" -> {
        System.out.println("SALONEK");
        System.out.println(plus);
      }
      case "PRESS" -> {
        System.out.println("TISK");
        System.out.println(1 + plus);
      }
      default -> {
        System.out.println("RECEPCE");
        System.out.println(1 + plus);
      }
    }
    // UPRAVUJ POTUD

  }
}
