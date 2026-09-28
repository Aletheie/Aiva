import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    int n = Integer.parseInt(in.nextLine());
    for (int i = 0; i < n; i++) {
      String text = in.nextLine();
      try {
        System.out.println("OK: " + Clock.read(text));
      } catch (NumberFormatException e) {
        System.out.println("FORMAT");
      } catch (IllegalArgumentException e) {
        System.out.println("ROZSAH");
      }
    }
  }
}

class Parts {
  static int[] read(String raw) {
    String s = raw.trim();
    if (!s.matches("[0-9]{2}:[0-9]{2}")) throw new NumberFormatException("format");
    return new int[] {Integer.parseInt(s.substring(0, 2)), Integer.parseInt(s.substring(3))};
  }
}

class Clock {
  // UPRAVUJ ODSUD
  static int read(String text) {
    int[] parts = Parts.read(text);
    return parts[0] + parts[1];
  }
  // UPRAVUJ POTUD
}
