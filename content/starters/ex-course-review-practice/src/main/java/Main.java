import java.util.List;

public class Main {
    record Result(String name, int points) {
        Result {
            if (name == null || name.isBlank() || points < 0) {
                throw new IllegalArgumentException("Neplatný výsledek");
            }
        }
    }

    static List<String> successful(List<Result> results) {
        return results.stream()
                .filter(result -> result.points() >= 10)
                .map(Result::name)
                .sorted()
                .toList();
    }

    public static void main(String[] args) {
        List<Result> results = List.of(
                new Result("Eva", 12),
                new Result("Ada", 10),
                new Result("Iva", 9));
        System.out.println(successful(results)); // [Ada, Eva]
    }
}
