import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    String line = input.nextLine();
    int separator = line.indexOf("|");
    // UPRAVUJ ODSUD
    String sender = line.substring(0, separator).trim();
    String message = line.substring(separator + 1).trim();
    boolean anonymous = sender.equalsIgnoreCase("A");
    System.out.println("Od: " + sender);
    System.out.println("Text: " + message);
    System.out.println("Anonym: " + anonymous);
    // UPRAVUJ POTUD

  }
}
