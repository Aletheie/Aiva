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
    Map<String, Integer> counts = new TreeMap<>();
    for (Alibi row : rows) counts.put(row.person(), counts.getOrDefault(row.person(), 0) + 1);
    List<String> result = new ArrayList<>();
    for (String person : counts.keySet()) result.add(person + ":" + counts.get(person) + ":ROZPOR");
    return result;
    // UPRAVUJ POTUD
  }

  record Alibi(String person, String place) {}
}
