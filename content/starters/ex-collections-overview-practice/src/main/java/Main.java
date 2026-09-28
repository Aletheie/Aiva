import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class Main {
    public static void main(String[] args) {
        List<String> names = new ArrayList<>();
        names.add("Ada");
        names.add("Eva");
        names.add("Ada");
        System.out.println(names.get(1)); // Eva
        System.out.println(names.size()); // 3

        Set<String> unique = new HashSet<>(names);
        System.out.println(unique.size()); // 2
        System.out.println(unique.contains("Ada")); // true

        Map<String, Integer> scores = new HashMap<>();
        scores.put("Ada", 8);
        scores.put("Ada", 10);
        System.out.println(scores.get("Ada")); // 10
        System.out.println(scores.getOrDefault("Iva", 0)); // 0
    }
}
