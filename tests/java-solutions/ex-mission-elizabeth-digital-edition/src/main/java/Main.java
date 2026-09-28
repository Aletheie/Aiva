import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    String title = in.nextLine();
    int pages = in.nextInt(), limit = in.nextInt(), requested = in.nextInt();
    EBook book = new EBook(title, pages, limit);
    System.out.println(book.summary());
    System.out.println("Strany: " + book.pages());
    System.out.println("Povoleno: " + book.canReadOn(requested));
  }
}

class Book {
  private final String title;
  private final int pages;

  Book(String title, int pages) {
    this.title = title;
    this.pages = pages;
  }

  String summary() {
    return title + "/" + pages;
  }

  int pages() {
    return pages;
  }
}

class EBook extends Book {
  // UPRAVUJ ODSUD
  private final int limit;

  EBook(String title, int pages, int limit) {
    super(title, pages);
    this.limit = limit;
  }

  @Override
  String summary() {
    return super.summary() + "/digital";
  }

  boolean canReadOn(int devices) {
    return devices >= 1 && devices <= limit;
  }
  // UPRAVUJ POTUD
}
