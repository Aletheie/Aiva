import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int age = input.nextInt();
    boolean invited = input.nextBoolean(), blocked = input.nextBoolean();
    int places = input.nextInt();
    // UPRAVUJ ODSUD
    boolean eligible = age >= 18 && invited && !blocked;
    boolean inside = eligible && places > 0;
    boolean waiting = eligible && places == 0;
    // UPRAVUJ POTUD
    System.out.println("Dovnitr: " + inside);
    System.out.println("Ceka: " + waiting);
  }
}
