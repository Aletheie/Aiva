import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int guests = input.nextInt(),
        extra = input.nextInt(),
        price = input.nextInt(),
        deposit = input.nextInt();
    // UPRAVUJ ODSUD
    int total = guests * price;
    guests = guests + extra;
    int due = total;
    System.out.println("Hoste: " + guests);
    System.out.println("Celkem: " + total);
    System.out.println("Doplatek: " + due);
    // UPRAVUJ POTUD

  }
}
