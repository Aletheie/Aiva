import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int capacity = input.nextInt(), reserved = input.nextInt(), requested = input.nextInt();
    // UPRAVUJ ODSUD
    if (requested == 0) {
      System.out.println("NEPLATNA");
    } else if (requested <= capacity - reserved) {
      reserved += requested;
      System.out.println("POTVRZENA");
    } else {
      System.out.println("CEKACI");
    }
    // UPRAVUJ POTUD
    System.out.println("Volno: " + (capacity - reserved));
  }
}
