import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);

    // UPRAVUJ ODSUD
    int people = input.nextInt();
    int price = input.nextInt();
    int discount = input.nextInt();
    String name = input.nextLine();
    int total = people * (price - discount);
    System.out.println("Rezervace: " + name);
    System.out.println("Celkem: " + total);
    // UPRAVUJ POTUD

  }
}
