import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int guests = input.nextInt(),
        extra = input.nextInt(),
        price = input.nextInt(),
        deposit = input.nextInt();
    // UPRAVUJ ODSUD
    guests = guests + extra;
    int total = guests * price;
    int due = total - deposit;
    System.out.println("Hoste: " + guests);
    System.out.println("Celkem: " + total);
    System.out.println("Doplatek: " + due);
    // UPRAVUJ POTUD

  }
}
