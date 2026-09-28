import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int n = input.nextInt();
    List<Supply> rows = new ArrayList<>();
    for (int i = 0; i < n; i++)
      rows.add(new Supply(input.next(), input.nextInt(), input.nextInt()));
    // UPRAVUJ ODSUD
    java.util.function.Predicate<Supply> usable = s -> s.stock() > 0 || s.days() > 0;
    java.util.function.Predicate<Supply> lowStock = s -> s.stock() <= 5;
    // UPRAVUJ POTUD
    System.out.println("Pouzitelne: " + select(rows, usable));
    System.out.println("Doplnit: " + select(rows, lowStock));
  }

  record Supply(String name, int stock, int days) {}

  static List<String> select(List<Supply> rows, java.util.function.Predicate<Supply> rule) {
    List<String> result = new ArrayList<>();
    for (Supply row : rows) if (rule.test(row)) result.add(row.name());
    return result;
  }
}
