import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Scanner;

public class Main {
    static Optional<String> clue(Map<String, String> archive, String code) {
        return Optional.ofNullable(archive.get(code))
                .map(String::strip)
                .filter(place -> !place.isEmpty());
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int count = Integer.parseInt(input.nextLine());
        Map<String, String> archive = new HashMap<>();
        for (int i = 0; i < count; i++) {
            String[] parts = input.nextLine().split("\\|", -1);
            archive.put(parts[0], parts[1]);
        }
        String wanted = input.nextLine();
        System.out.println("Stopa: " + clue(archive, wanted).orElse("zatim bez stopy"));
    }
}
