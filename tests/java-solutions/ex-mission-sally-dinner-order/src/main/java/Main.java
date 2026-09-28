import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);

    // UPRAVUJ ODSUD
    int people = Integer.parseInt(input.nextLine().trim());
    int price = Integer.parseInt(input.nextLine().trim());
    int discount = Integer.parseInt(input.nextLine().trim());
    String name = input.nextLine();
    int total = people * price - discount;
    System.out.println("Rezervace: " + name);
    System.out.println("Celkem: " + total);
    // UPRAVUJ POTUD

  }
}
