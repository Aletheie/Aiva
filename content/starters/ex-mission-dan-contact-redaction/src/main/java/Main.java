import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    String raw = input.nextLine();
    // UPRAVUJ ODSUD
    String email = raw;
    int at = email.indexOf("@");
    System.out.println("Kontakt: " + email);
    System.out.println("Skryto znaku: " + at);
    // UPRAVUJ POTUD

  }
}
