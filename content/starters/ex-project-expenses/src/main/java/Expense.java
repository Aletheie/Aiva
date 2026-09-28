public record Expense(String category, long cents) {
    public Expense {
        if (category == null || category.isBlank()) throw new IllegalArgumentException("Kategorie chybí");
        if (cents < 0) throw new IllegalArgumentException("Výdaj nesmí být záporný");
    }
}
