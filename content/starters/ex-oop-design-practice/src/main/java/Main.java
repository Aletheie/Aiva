class Book {
    private final String title;
    private boolean borrowed;

    public Book(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public boolean borrow() {
        if (borrowed) {
            return false;
        }
        borrowed = true;
        return true;
    }

    public void giveBack() {
        borrowed = false;
    }
}

public class Main {
    public static void main(String[] args) {
        Book book = new Book("Duna");
        System.out.println(book.getTitle()); // Duna
        System.out.println(book.borrow());   // true
        System.out.println(book.borrow());   // false
        book.giveBack();
        System.out.println(book.borrow());   // true
    }
}
