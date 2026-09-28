import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int n = input.nextInt();
    List<Alibi> rows = new ArrayList<>();
    for (int i = 0; i < n; i++) rows.add(new Alibi(input.next(), input.next()));
    List<String> report = summarize(rows);
    if (report.isEmpty()) System.out.println("BEZ ZAZNAMU");
    else for (String line : report) System.out.println(line);
  }

  static List<String> summarize(List<Alibi> rows) {
    // UPRAVUJ ODSUD
    Map<String, Set<String>> places = new TreeMap<>();
    for (Alibi row : rows) {
      if (!places.containsKey(row.person())) places.put(row.person(), new HashSet<>());
      places.get(row.person()).add(row.place());
    }
    List<String> result = new ArrayList<>();
    for (String person : places.keySet()) {
      int count = places.get(person).size();
      result.add(person + ":" + count + ":" + (count > 1 ? "ROZPOR" : "OK"));
    }
    return result;
    // UPRAVUJ POTUD
  }

  record Alibi(String person, String place) {}
}
