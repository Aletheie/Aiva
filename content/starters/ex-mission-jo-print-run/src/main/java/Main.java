import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    String copiesText = input.nextLine(), pagesText = input.nextLine();
    // UPRAVUJ ODSUD
    int copies = Integer.parseInt(copiesText);
    int pages = Integer.parseInt(pagesText);
    long pagesTotal = copies * pages;
    System.out.println("Vytisky: " + copies);
    System.out.println("Strany: " + pagesTotal);
    // UPRAVUJ POTUD

  }
}
