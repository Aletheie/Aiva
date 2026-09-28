import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int hour = input.nextInt();
    boolean invited = input.nextBoolean(), alarm = input.nextBoolean(), ring = input.nextBoolean();
    // UPRAVUJ ODSUD
    if (hour > 6 && hour <= 18 && !ring) System.out.println("CEKEJ");
    else if (invited || ring) System.out.println("VYRAZIT");
    else System.out.println("ODMITNUTO");
    // UPRAVUJ POTUD

  }
}
