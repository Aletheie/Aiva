import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int n = Integer.parseInt(input.nextLine());
    String[] lines = new String[n];
    for (int i = 0; i < n; i++) lines[i] = input.nextLine();
    audit(lines);
  }

  static void audit(String[] lines) {
    // UPRAVUJ ODSUD
    int accepted = 0, attempts = 0;
    for (String line : lines) {
      try {
        int value = Parser.read(line);
        System.out.println("OK: " + value);
        accepted++;
      } catch (NumberFormatException e) {
        System.out.println("FORMAT");
      } catch (IllegalArgumentException e) {
        System.out.println("ROZSAH");
      } finally {
        attempts++;
      }
    }
    System.out.println("Prijato: " + accepted);
    System.out.println("Pokusy: " + attempts);
    // UPRAVUJ POTUD
  }

  static class Parser {
    static int read(String text) {
      int n = Integer.parseInt(text.trim());
      if (n < 1 || n > 50) throw new IllegalArgumentException("range");
      return n;
    }
  }
}
