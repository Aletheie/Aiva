import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    String name = in.nextLine();
    int points = in.nextInt(), next = in.nextInt();
    Pair<String, Integer> original = new Pair<>(name, points);
    Pair<Integer, String> swapped = original.swapped();
    Pair<String, Integer> changed = original.withRight(next);
    Integer score = swapped.left();
    System.out.println("Puvodni: " + original.left() + "/" + original.right());
    System.out.println("Obracene: " + score + "/" + swapped.right());
    System.out.println("Zmena: " + changed.left() + "/" + changed.right());
    System.out.println("Stejny objekt: " + (original == changed));
  }
}

class Pair<A, B> {
  // UPRAVUJ ODSUD
  private A left;
  private B right;

  Pair(A left, B right) {
    this.left = left;
    this.right = right;
  }

  A left() {
    return left;
  }

  B right() {
    return right;
  }

  Pair<B, A> swapped() {
    return new Pair<>(right, left);
  }

  Pair<A, B> withRight(B value) {
    right = value;
    return this;
  }
  // UPRAVUJ POTUD
}
