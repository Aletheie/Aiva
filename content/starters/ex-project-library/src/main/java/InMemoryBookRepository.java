import java.util.ArrayList;
import java.util.List;
public class InMemoryBookRepository implements BookRepository {
    private List<Book> books = new ArrayList<>();
    public List<Book> load() { return List.copyOf(books); }
    public void save(List<Book> books) { this.books = new ArrayList<>(books); }
}
