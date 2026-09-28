import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.LinkedHashMap;
import java.util.Map;
import org.yaml.snakeyaml.LoaderOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.SafeConstructor;

public class Main {
    public static void main(String[] args) throws IOException {
        LoaderOptions options = new LoaderOptions();
        options.setAllowDuplicateKeys(false);
        options.setMaxAliasesForCollections(20);
        options.setCodePointLimit(100_000);
        Yaml yaml = new Yaml(new SafeConstructor(options));

        Object loaded = yaml.load("name: Java klub\nport: 8080\n");
        if (!(loaded instanceof Map<?, ?> values)) {
            throw new IllegalArgumentException("Konfigurace musí být mapa");
        }
        if (!(values.get("name") instanceof String name) || name.isBlank()) {
            throw new IllegalArgumentException("Chybí textové jméno");
        }
        if (!(values.get("port") instanceof Integer port) || port < 1 || port > 65535) {
            throw new IllegalArgumentException("Port musí být celé číslo 1–65535");
        }
        System.out.println(name + ": " + port); // Java klub: 8080

        Map<String, Object> saved = new LinkedHashMap<>();
        saved.put("name", name);
        saved.put("port", port);
        Files.writeString(Path.of("config.yaml"), yaml.dump(saved), StandardCharsets.UTF_8);
    }
}
