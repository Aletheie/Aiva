import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    int n = Integer.parseInt(in.nextLine());
    List<String> previous = new ArrayList<>();
    for (int i = 0; i < n; i++) previous.add(in.nextLine());
    String entry = in.nextLine();
    Path dir = Files.createTempDirectory("aiva-journal-");
    Path file = dir.resolve("diary.txt");
    try {
      if (n > 0) Files.write(file, previous, StandardCharsets.UTF_8);
      try {
        Journal.append(file, entry);
        System.out.println("ULOZENO");
      } catch (IllegalArgumentException e) {
        System.out.println("ODMITNUTO");
      }
      System.out.println("Soubor: " + Files.exists(file));
      List<String> rows =
          Files.exists(file) ? Files.readAllLines(file, StandardCharsets.UTF_8) : List.of();
      System.out.println("Radky: " + rows.size());
      for (String row : rows) System.out.println("|" + row);
    } finally {
      Fixture.delete(dir);
    }
  }
}

class Fixture {
  static void delete(Path dir) throws IOException {
    try (var stream = Files.walk(dir)) {
      for (Path p : stream.sorted(Comparator.reverseOrder()).toList()) Files.deleteIfExists(p);
    }
  }
}

class Journal {
  // UPRAVUJ ODSUD
  static void append(Path file, String entry) throws IOException {
    String text = entry.trim();
    if (text.isEmpty()) throw new IllegalArgumentException("empty");
    Files.writeString(
        file,
        text + "\n",
        StandardCharsets.UTF_8,
        StandardOpenOption.CREATE,
        StandardOpenOption.APPEND);
  }
  // UPRAVUJ POTUD
}
