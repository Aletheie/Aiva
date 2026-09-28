import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int first = input.nextInt(), second = input.nextInt(), percent = input.nextInt();
    printQuote(first, percent);
    printQuote(second, percent);
    System.out.println("Puvodni: " + first + "," + second);
  }

  static void printQuote(int base, int percent) {
    // UPRAVUJ ODSUD
    int discount = base / 100 * percent;
    base = 1000;
    System.out.println("Sleva: " + discount);
    System.out.println("Nabidka: " + (base - discount));
    // UPRAVUJ POTUD
  }
}
