import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int hour = input.nextInt();
    boolean invited = input.nextBoolean(), alarm = input.nextBoolean(), ring = input.nextBoolean();
    // UPRAVUJ ODSUD
    if (!invited) System.out.println("ODMITNUTO");
    else if (alarm) System.out.println("CEKEJ");
    else if (hour >= 6 && hour < 18 && !ring) System.out.println("CEKEJ");
    else System.out.println("VYRAZIT");
    // UPRAVUJ POTUD

  }
}
