import java.util.List;
public class Main {
    public static void main(String[] args) {
        List<Expense> rows = List.of(new Expense("Doprava", 3200));
        System.out.println(rows.stream().mapToLong(Expense::cents).sum());
    }
}
