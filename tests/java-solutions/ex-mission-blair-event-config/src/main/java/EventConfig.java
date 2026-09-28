import java.util.*;
import org.yaml.snakeyaml.*;
import org.yaml.snakeyaml.constructor.SafeConstructor;

public class EventConfig {
  public record Config(int capacity, boolean reminders, String host) {}

  private static Object parse(String yaml) {
    LoaderOptions options = new LoaderOptions();
    options.setAllowDuplicateKeys(false);
    return new Yaml(new SafeConstructor(options)).load(yaml);
  }

  // UPRAVUJ ODSUD
  public static Config read(String yaml) {
    Object root = parse(yaml);
    if (!(root instanceof Map<?, ?> map)) throw new IllegalArgumentException("map required");
    Object capacity = map.get("capacity"), reminders = map.get("reminders"), host = map.get("host");
    if (!(capacity instanceof Integer n) || n < 1 || n > 200)
      throw new IllegalArgumentException("capacity");
    if (!(reminders instanceof Boolean enabled)) throw new IllegalArgumentException("reminders");
    if (!(host instanceof String name) || name.trim().isEmpty())
      throw new IllegalArgumentException("host");
    return new Config(n, enabled, name.trim());
  }
  // UPRAVUJ POTUD
}
