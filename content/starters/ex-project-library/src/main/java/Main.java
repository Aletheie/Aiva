public class Main {
    public static void main(String[] args) throws java.io.IOException {
        BookRepository repository = new InMemoryBookRepository();
        Book book = new Book("b-001", "Základy Javy", LoanState.AVAILABLE);
        repository.save(java.util.List.of(book.borrow()));
        System.out.println(repository.load());
    }
}
