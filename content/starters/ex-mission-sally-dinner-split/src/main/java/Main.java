import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int total = input.nextInt(), people = input.nextInt();
    // UPRAVUJ ODSUD
    int base = total / people;
    int extraPeople = 0;
    int regularTotal = total;
    System.out.println("Zaklad: " + base);
    System.out.println("Korunu navic: " + extraPeople);
    System.out.println("Ostatni celkem: " + regularTotal);
    // UPRAVUJ POTUD

  }
}
