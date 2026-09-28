import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    String previous = in.nextLine(), text = in.nextLine();
    boolean fail = Boolean.parseBoolean(in.nextLine());
    Path dir = Files.createTempDirectory("aiva-draft-");
    Path file = dir.resolve("draft.txt");
    try {
      Files.writeString(file, previous, StandardCharsets.UTF_8);
      try {
        DraftStore.save(file, text, new Replacer(fail));
        System.out.println("OK");
      } catch (IllegalArgumentException e) {
        System.out.println("NEPLATNE");
      } catch (IOException e) {
        System.out.println("CHYBA");
      }
      System.out.println("Obsah: " + Files.readString(file, StandardCharsets.UTF_8));
      try (var paths = Files.list(dir)) {
        System.out.println("Docasne: " + paths.filter(p -> !p.equals(file)).count());
      }
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

class Replacer {
  private final boolean fail;

  Replacer(boolean fail) {
    this.fail = fail;
  }

  void replace(Path temporary, Path target) throws IOException {
    if (fail) throw new IOException("simulated replacement failure");
    Files.move(temporary, target, StandardCopyOption.REPLACE_EXISTING);
  }
}

class DraftStore {
  // UPRAVUJ ODSUD
  static void save(Path file, String text, Replacer replacer) throws IOException {
    if (text.isBlank()) throw new IllegalArgumentException("empty draft");
    Path temporary = Files.createTempFile(file.getParent(), "draft-", ".tmp");
    try {
      Files.writeString(temporary, text, StandardCharsets.UTF_8);
      replacer.replace(temporary, file);
    } finally {
      Files.deleteIfExists(temporary);
    }
  }
  // UPRAVUJ POTUD
}
