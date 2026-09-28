public class Newsletter {
  public static String subject(String title) {
    String normalized = title.trim();
    return "Upper East Side | " + (normalized.isEmpty() ? "(bez titulku)" : normalized);
  }
}
