import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;

public class Main {
    public static void main(String[] args) {
        Path directory = Path.of("practice-data");
        Path file = directory.resolve("notes.txt");
        try {
            Files.createDirectories(directory);
            Files.writeString(file, "Příliš žluťoučký kůň\n", StandardCharsets.UTF_8);
            Files.writeString(file, "Druhý řádek\n", StandardCharsets.UTF_8,
                    StandardOpenOption.APPEND);
            String text = Files.readString(file, StandardCharsets.UTF_8);
            System.out.print(text);
        } catch (IOException error) {
            System.out.println("Soubor nelze zpracovat: " + error.getMessage());
        }
    }
}
