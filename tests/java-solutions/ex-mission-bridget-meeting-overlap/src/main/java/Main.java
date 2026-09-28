import java.util.*;

public class Main {
  public static void main(String[] args) {
    Scanner in = new Scanner(System.in);
    Meeting a = new Meeting(in.nextInt(), in.nextInt()),
        b = new Meeting(in.nextInt(), in.nextInt());
    System.out.println("Konce: " + a.end() + "," + b.end());
    System.out.println("Prekryv: " + a.overlaps(b));
    System.out.println("Obracene: " + b.overlaps(a));
  }
}

class Meeting {
  // UPRAVUJ ODSUD
  private final int start, duration;

  Meeting(int start, int duration) {
    this.start = start;
    this.duration = duration;
  }

  int end() {
    return start + duration;
  }

  boolean overlaps(Meeting other) {
    return start < other.end() && other.start < end();
  }
  // UPRAVUJ POTUD
}
