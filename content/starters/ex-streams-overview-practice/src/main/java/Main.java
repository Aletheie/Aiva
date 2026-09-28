import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<String> names = List.of("Ada", "Eliška", "Eva", "Eliška");
        List<Integer> lengths = new ArrayList<>();
        for (String name : names) {
            if (name.length() >= 4) {
                lengths.add(name.length());
            }
        }
        System.out.println(lengths); // [6, 6]

        List<Integer> streamed = names.stream()
                .filter(name -> name.length() >= 4)
                .map(String::length)
                .toList();
        System.out.println(streamed); // [6, 6]
    }
}
