import com.google.gson.*;

public class EvidenceReader {
  public record Evidence(String id, String label, int confidence) {}

  // UPRAVUJ ODSUD
  public static Evidence read(String json) {
    return new Gson().fromJson(json, Evidence.class);
  }
  // UPRAVUJ POTUD
}
