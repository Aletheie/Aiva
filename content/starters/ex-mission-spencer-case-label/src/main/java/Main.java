import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    String codeText = input.nextLine(),
        secondsText = input.nextLine(),
        verifiedText = input.nextLine();
    // UPRAVUJ ODSUD
    int code = Integer.parseInt(codeText);
    int seconds = Integer.parseInt(secondsText);
    int minutes = seconds / 60;
    String verified = verifiedText;
    System.out.println("Spis: " + code);
    System.out.println("Minuty: " + minutes);
    System.out.println("Overeno: " + verified);
    // UPRAVUJ POTUD

  }
}
