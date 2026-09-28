import java.util.*;
import java.util.stream.Collectors;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int n = input.nextInt();
    List<Event> rows = new ArrayList<>();
    for (int i = 0; i < n; i++)
      rows.add(new Event(input.next(), input.nextInt(), input.nextBoolean()));
    List<Event> result = timeline(rows);
    for (Event e : result) System.out.println(e.id() + "@" + e.minute());
    System.out.println("Pocet: " + result.size());
    System.out.println(
        "Rozpeti: "
            + (result.isEmpty()
                ? 0
                : result.get(result.size() - 1).minute() - result.get(0).minute()));
  }

  static List<Event> timeline(List<Event> rows) {
    // UPRAVUJ ODSUD
    return rows.stream()
        .filter(Event::verified)
        .collect(Collectors.toMap(Event::id, e -> e, (a, b) -> a.minute() <= b.minute() ? a : b))
        .values()
        .stream()
        .sorted(Comparator.comparingInt(Event::minute).thenComparing(Event::id))
        .toList();
    // UPRAVUJ POTUD
  }

  record Event(String id, int minute, boolean verified) {}
}
