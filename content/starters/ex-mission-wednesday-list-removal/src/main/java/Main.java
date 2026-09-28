import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int n = Integer.parseInt(input.nextLine());
    List<Note> working = new ArrayList<>();
    for (int i = 0; i < n; i++)
      working.add(new Note(input.nextLine(), Boolean.parseBoolean(input.nextLine())));
    System.out.println("Odebrano: " + clean(working));
    System.out.println("Zbyva: " + working.stream().map(Note::text).toList());
  }

  static int clean(List<Note> working) {
    // UPRAVUJ ODSUD
    int removed = 0;
    for (int i = 0; i < working.size(); i++) {
      if (!working.get(i).verified()) {
        working.remove(i);
        removed++;
      }
    }
    return removed;
    // UPRAVUJ POTUD
  }

  record Note(String text, boolean verified) {}
}
