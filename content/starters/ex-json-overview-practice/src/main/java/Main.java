import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonParseException;
import com.google.gson.Strictness;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;

public class Main {
    record Profile(String name, int points) {}

    public static void main(String[] args) {
        Gson gson = new GsonBuilder()
                .setStrictness(Strictness.STRICT)
                .setPrettyPrinting()
                .create();
        Path file = Path.of("profile.json");
        try {
            Profile original = new Profile("Ada", 12);
            String json = gson.toJson(original);
            Files.writeString(file, json, StandardCharsets.UTF_8);
            String saved = Files.readString(file, StandardCharsets.UTF_8);
            Profile loaded = gson.fromJson(saved, Profile.class);
            if (loaded == null || loaded.name() == null
                    || loaded.name().isBlank() || loaded.points() < 0) {
                throw new IllegalArgumentException("Neplatný profil");
            }
            System.out.println(loaded.name() + ": " + loaded.points());
        } catch (IOException error) {
            System.out.println("Soubor: " + error.getMessage());
        } catch (JsonParseException | IllegalArgumentException error) {
            System.out.println("Data: " + error.getMessage());
        }
    }
}
