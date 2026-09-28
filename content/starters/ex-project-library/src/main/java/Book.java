public record Book(String id, String title, LoanState state) {
    public Book borrow() {
        if (state != LoanState.AVAILABLE) throw new IllegalStateException("Kniha už je vypůjčená");
        return new Book(id, title, LoanState.BORROWED);
    }
    public Book giveBack() {
        if (state != LoanState.BORROWED) throw new IllegalStateException("Kniha není vypůjčená");
        return new Book(id, title, LoanState.AVAILABLE);
    }
}
