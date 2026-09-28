import java.io.IOException;
import java.util.List;
public interface BookRepository {
    List<Book> load() throws IOException;
    void save(List<Book> books) throws IOException;
}
