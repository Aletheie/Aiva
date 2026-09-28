import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;

public class PantryReport {
  public static String report(Path file) throws Exception {
    List<String> lines = Files.readAllLines(file, StandardCharsets.UTF_8);
    List<String> out = new ArrayList<>();
    for (String line : lines) {
      if (line.isBlank() || line.startsWith("#")) continue;
      String[] parts = line.split(",", -1);
      if (parts.length != 3) throw new IllegalArgumentException("Expected name,stock,minimum");
      String name = parts[0].trim();
      int stock = Integer.parseInt(parts[1].trim()), minimum = Integer.parseInt(parts[2].trim());
      if (name.isEmpty() || stock < 0 || minimum < 0)
        throw new IllegalArgumentException("Invalid stock row");
      if (stock < minimum) out.add(name + ": doplnit " + (minimum - stock));
    }
    return out.isEmpty() ? "Vseho je dost" : String.join("\n", out);
  }

  public static void main(String[] args) throws Exception {
    if (args.length != 1)
      throw new IllegalArgumentException("Usage: PantryReport path/to/file.csv");
    System.out.println(report(Path.of(args[0])));
  }
}
