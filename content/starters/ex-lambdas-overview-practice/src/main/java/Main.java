import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;

public class Main {
    static List<String> select(List<String> names, Predicate<String> rule) {
        List<String> result = new ArrayList<>();
        for (String name : names) {
            if (rule.test(name)) {
                result.add(name);
            }
        }
        return result;
    }

    public static void main(String[] args) {
        List<String> names = List.of("Ada", "Eliška", "Eva");
        int minimumLength = 4;
        List<String> longNames = select(names, name -> name.length() >= minimumLength);
        System.out.println(longNames); // [Eliška]
    }
}
