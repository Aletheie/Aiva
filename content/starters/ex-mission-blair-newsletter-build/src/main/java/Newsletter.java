import com.google.gson.Gson;

public class Newsletter {
  public static String preview(String headline) {
    return new Gson().toJson(new Draft(headline.trim()));
  }

  record Draft(String title) {}
}
