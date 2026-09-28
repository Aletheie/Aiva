import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int teams = input.nextInt(), stock = input.nextInt();
    // UPRAVUJ ODSUD
    int unfilled = 0;
    for (int i = 1; i < teams; i++) {
      int wanted = input.nextInt();
      stock -= wanted;
      System.out.println("Tym " + i + ": " + wanted);
    }
    System.out.println("Zbyva: " + stock);
    System.out.println("Neuspokojeno: " + unfilled);
    // UPRAVUJ POTUD

  }
}
