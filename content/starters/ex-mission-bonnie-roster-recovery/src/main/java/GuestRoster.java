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
    guests.clear();
    try {
      for (JsonElement value : JsonParser.parseString(Files.readString(file)).getAsJsonArray())
        guests.add(value.getAsString());
      return true;
    } catch (Exception e) {
      return false;
    }
  }
  // UPRAVUJ POTUD
}
