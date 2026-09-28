import com.google.gson.*;

public class EvidenceReader {
  public record Evidence(String id, String label, int confidence) {}

  // UPRAVUJ ODSUD
  public static Evidence read(String json) {
    try {
      JsonElement root =
          new GsonBuilder()
              .setStrictness(Strictness.STRICT)
              .create()
              .fromJson(json, JsonElement.class);
      if (root == null || !root.isJsonObject())
        throw new IllegalArgumentException("object required");
      JsonObject obj = root.getAsJsonObject();
      String id = text(obj, "id"), label = text(obj, "label");
      JsonElement value = obj.get("confidence");
      if (value == null || !value.isJsonPrimitive() || !value.getAsJsonPrimitive().isNumber())
        throw new IllegalArgumentException("number required");
      int confidence;
      try {
        confidence = new java.math.BigDecimal(value.getAsString()).intValueExact();
      } catch (ArithmeticException | NumberFormatException e) {
        throw new IllegalArgumentException("integer required", e);
      }
      if (confidence < 0 || confidence > 100)
        throw new IllegalArgumentException("confidence range");
      return new Evidence(id, label, confidence);
    } catch (JsonParseException e) {
      throw new IllegalArgumentException("invalid JSON", e);
    }
  }

  private static String text(JsonObject obj, String key) {
    JsonElement value = obj.get(key);
    if (value == null || !value.isJsonPrimitive() || !value.getAsJsonPrimitive().isString())
      throw new IllegalArgumentException(key);
    String text = value.getAsString().trim();
    if (text.isEmpty()) throw new IllegalArgumentException(key);
    return text;
  }
  // UPRAVUJ POTUD
}
