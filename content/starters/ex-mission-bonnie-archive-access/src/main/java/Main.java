import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    boolean card = input.nextBoolean(),
        invite = input.nextBoolean(),
        blocked = input.nextBoolean(),
        open = input.nextBoolean();
    // UPRAVUJ ODSUD
    boolean access = open && !blocked && card || invite;
    boolean review = !card || !invite;
    // UPRAVUJ POTUD
    System.out.println("Vstup: " + access);
    System.out.println("Overit: " + review);
  }
}
