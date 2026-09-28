import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    int n = Integer.parseInt(in.nextLine());
    List<Clue> clues = new ArrayList<>();
    for (int i = 0; i < n; i++)
      clues.add(
          new Clue(
              in.nextLine(),
              Integer.parseInt(in.nextLine()),
              in.nextLine(),
              Boolean.parseBoolean(in.nextLine())));
    int k = Integer.parseInt(in.nextLine());
    Set<String> withdrawn = new HashSet<>();
    for (int i = 0; i < k; i++) withdrawn.add(in.nextLine());
    Reporter.print(CaseReview.timeline(clues, withdrawn));
  }
}

record Clue(String id, int minute, String place, boolean confirmed) {}

class Reporter {
  static void print(List<Clue> timeline) {
    for (Clue c : timeline) System.out.println(c.minute() + ":" + c.id() + ":" + c.place());
    Map<String, Integer> places = new TreeMap<>();
    for (Clue c : timeline) places.merge(c.place(), 1, Integer::sum);
    System.out.println("Mista: " + places);
    System.out.println(
        "Rozpeti: "
            + (timeline.isEmpty()
                ? 0
                : timeline.get(timeline.size() - 1).minute() - timeline.get(0).minute()));
  }
}

class CaseReview {
  // UPRAVUJ ODSUD
  static List<Clue> timeline(List<Clue> input, Set<String> withdrawn) {
    return new ArrayList<>(input);
  }
  // UPRAVUJ POTUD
}
