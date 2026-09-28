import java.util.*;
import java.util.stream.Collectors;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int n = input.nextInt();
    List<Shift> rows = new ArrayList<>();
    for (int i = 0; i < n; i++)
      rows.add(new Shift(input.next(), input.nextInt(), input.nextBoolean()));
    // UPRAVUJ ODSUD
    Map<String, Integer> totals =
        rows.stream()
            .filter(s -> s.confirmed() && s.hours() > 0)
            .collect(
                Collectors.groupingBy(
                    Shift::name, TreeMap::new, Collectors.summingInt(Shift::hours)));
    // UPRAVUJ POTUD
    totals.forEach((name, hours) -> System.out.println(name + ":" + hours));
    System.out.println("Celkem: " + totals.values().stream().mapToInt(Integer::intValue).sum());
    System.out.println("Lide: " + totals.size());
  }

  record Shift(String name, int hours, boolean confirmed) {}
}
