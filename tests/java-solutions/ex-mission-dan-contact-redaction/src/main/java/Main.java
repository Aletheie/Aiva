import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    String raw = input.nextLine();
    // UPRAVUJ ODSUD
    String email = raw.trim();
    int at = email.indexOf("@");
    String domain = email.substring(at + 1).toLowerCase(Locale.ROOT);
    System.out.println("Kontakt: ***@" + domain);
    System.out.println("Skryto znaku: " + at);
    // UPRAVUJ POTUD

  }
}
