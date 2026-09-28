import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    Diary diary = new Diary();
    int n = in.nextInt();
    for (int i = 0; i < n; i++) System.out.println(diary.reserve(in.nextInt(), in.nextInt()));
    System.out.println("Pocet: " + diary.size());
  }
}

record Slot(int start, int end) {}

class Diary {
  // UPRAVUJ ODSUD
  private final List<Slot> slots = new ArrayList<>();

  boolean reserve(int start, int end) {
    slots.add(new Slot(start, end));
    return true;
  }

  int size() {
    return slots.size();
  }
  // UPRAVUJ POTUD
}
