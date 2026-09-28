import com.google.gson.*;
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class GuestRoster {
  private List<String> guests = new ArrayList<>(List.of("Elena"));

  public List<String> snapshot() {
    return new ArrayList<>(guests);
  }

  // UPRAVUJ ODSUD
  public boolean load(Path file) {
    try {
      String json = Files.readString(file, java.nio.charset.StandardCharsets.UTF_8);
      JsonElement root =
          new GsonBuilder()
              .setStrictness(Strictness.STRICT)
              .create()
              .fromJson(json, JsonElement.class);
      if (root == null || !root.isJsonArray()) return false;
      List<String> candidate = new ArrayList<>();
      Set<String> seen = new HashSet<>();
      for (JsonElement value : root.getAsJsonArray()) {
        if (!value.isJsonPrimitive() || !value.getAsJsonPrimitive().isString()) return false;
        String name = value.getAsString().trim();
        if (name.isEmpty() || !seen.add(name)) return false;
        candidate.add(name);
      }
      guests = candidate;
      return true;
    } catch (IOException | JsonParseException e) {
      return false;
    }
  }
  // UPRAVUJ POTUD
}
