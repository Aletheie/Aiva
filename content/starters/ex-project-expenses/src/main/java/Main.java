public class Main {
    public static void main(String[] args) {
        Expense expense = new Expense("Doprava", 3200);
        System.out.println(expense.category() + ": " + expense.cents());
    }
}
