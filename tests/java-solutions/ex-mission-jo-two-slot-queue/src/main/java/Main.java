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
  private T first, second;

  boolean add(T value) {
    if (value == null || second != null) return false;
    if (first == null) first = value;
    else second = value;
    return true;
  }

  T take() {
    T result = first;
    first = second;
    second = null;
    return result;
  }

  int size() {
    return first == null ? 0 : second == null ? 1 : 2;
  }
  // UPRAVUJ POTUD
}
