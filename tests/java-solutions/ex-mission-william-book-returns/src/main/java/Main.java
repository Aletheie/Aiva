import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int days = input.nextInt();
    boolean receipt = input.nextBoolean(), sealed = input.nextBoolean();
    // UPRAVUJ ODSUD
    if (days < 0) System.out.println("CHYBA");
    else if (receipt && days <= 14) System.out.println("PENIZE");
    else if (sealed && days <= 30) System.out.println("VYMENA");
    else System.out.println("ODMITNUTO");
    // UPRAVUJ POTUD

  }
}
