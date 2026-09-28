import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    Slots<String> queue = new Slots<>();
    System.out.println("Null: " + queue.add(null));
    int n = in.nextInt();
    for (int i = 0; i < n; i++) {
      String op = in.next();
      if (op.equals("ADD")) System.out.println("Pridano: " + queue.add(in.next()));
      else System.out.println("Odebrano: " + queue.take());
      System.out.println("Pocet: " + queue.size());
    }
    Slots<Integer> numbers = new Slots<>();
    numbers.add(7);
    numbers.add(8);
    Integer first = numbers.take();
    Integer second = numbers.take();
    System.out.println("Cisla: " + first + "," + second);
  }
}

class Slots<T> {
  // UPRAVUJ ODSUD
  private T first;

  boolean add(T value) {
    first = value;
    return true;
  }

  T take() {
    return first;
  }

  int size() {
    return first == null ? 0 : 1;
  }
  // UPRAVUJ POTUD
}
