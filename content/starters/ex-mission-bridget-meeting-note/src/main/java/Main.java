import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);

    // UPRAVUJ ODSUD
    String name = input.next();
    String place = input.nextLine();
    String note = input.nextLine();
    // UPRAVUJ POTUD
    System.out.println("Jmeno: " + name);
    System.out.println("Misto: " + place);
    System.out.println("Poznamka: " + note);
  }
}
