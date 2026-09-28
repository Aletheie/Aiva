import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int n = input.nextInt();
    List<Letter> rows = new ArrayList<>();
    for (int i = 0; i < n; i++)
      rows.add(new Letter(input.next(), input.nextBoolean(), input.nextInt()));
    // UPRAVUJ ODSUD
    Comparator<Letter> order =
        Comparator.comparing(Letter::urgent)
            .reversed()
            .thenComparing(Comparator.comparingInt(Letter::days).reversed())
            .thenComparing(Letter::sender);
    // UPRAVUJ POTUD
    List<Letter> sorted = rows.stream().sorted(order).toList();
    if (sorted.isEmpty()) System.out.println("BEZ DOPISU");
    else for (Letter row : sorted) System.out.println(row.sender());
  }

  record Letter(String sender, boolean urgent, int days) {}
}
