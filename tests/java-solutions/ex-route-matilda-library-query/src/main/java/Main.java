import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Main {
    static List<String> availableByAuthor(Connection db, String author) throws SQLException {
        List<String> titles = new ArrayList<>();
        String sql = "SELECT title FROM books WHERE author = ? AND available = TRUE ORDER BY title";
        try (PreparedStatement query = db.prepareStatement(sql)) {
            query.setString(1, author);
            try (ResultSet rows = query.executeQuery()) {
                while (rows.next()) titles.add(rows.getString("title"));
            }
        }
        return titles;
    }

    public static void main(String[] args) throws SQLException {
        try (Connection db = DriverManager.getConnection("jdbc:h2:mem:matilda")) {
            try (var setup = db.createStatement()) {
                setup.executeUpdate("CREATE TABLE books (id INT PRIMARY KEY, title VARCHAR(200) NOT NULL, author VARCHAR(100) NOT NULL, available BOOLEAN NOT NULL)");
            }
            try (PreparedStatement insert = db.prepareStatement("INSERT INTO books VALUES (?, ?, ?, ?)")) {
                String[][] books = {{"Emma", "Austen"}, {"Persuasion", "Austen"}, {"Dune", "Herbert"}, {"Morning tales", "O'Neil"}};
                for (int i = 0; i < books.length; i++) {
                    insert.setInt(1, i + 1);
                    insert.setString(2, books[i][0]);
                    insert.setString(3, books[i][1]);
                    insert.setBoolean(4, i != 1);
                    insert.executeUpdate();
                }
            }
            for (String author : List.of("Austen", "O'Neil", "Unknown", "' OR '1'='1")) {
                System.out.println(author + ": " + availableByAuthor(db, author));
            }
        }
    }
}
