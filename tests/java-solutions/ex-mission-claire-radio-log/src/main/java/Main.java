import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);

    // UPRAVUJ ODSUD
    int messages = 0, repeats = 0;
    String last = "-";
    while (true) {
      String line = input.nextLine().trim();
      if (line.equals("END")) break;
      if (line.isEmpty()) continue;
      if (messages > 0 && line.equals(last)) repeats++;
      else {
        messages++;
        last = line;
      }
    }
    System.out.println("Zpravy: " + messages);
    System.out.println("Opakovani: " + repeats);
    System.out.println("Posledni: " + last);
    // UPRAVUJ POTUD

  }
}
