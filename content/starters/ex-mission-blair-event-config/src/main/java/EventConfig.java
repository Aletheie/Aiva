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
    Map<?, ?> map = (Map<?, ?>) parse(yaml);
    return new Config(
        Integer.parseInt(map.get("capacity").toString()),
        Boolean.parseBoolean(map.get("reminders").toString()),
        map.get("host").toString());
  }
  // UPRAVUJ POTUD
}
