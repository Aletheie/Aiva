import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);

    // UPRAVUJ ODSUD
    int messages = 0, repeats = 0;
    String last = "-";
    String line = input.nextLine();
    while (!line.equals("END")) {
      messages++;
      last = line;
      line = input.nextLine();
    }
    System.out.println("Zpravy: " + messages);
    System.out.println("Opakovani: " + repeats);
    System.out.println("Posledni: " + last);
    // UPRAVUJ POTUD

  }
}
