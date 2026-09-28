import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    String title = in.nextLine(), reason = in.nextLine();
    Message[] messages = {new Publication(title), new Correction(title, reason)};
    for (Message message : messages) System.out.println(message.text());
  }
}

abstract class Message {
  private final String title;

  Message(String title) {
    this.title = title.trim();
  }

  String title() {
    return title;
  }

  abstract String text();
}

// UPRAVUJ ODSUD
class Publication extends Message {
  Publication(String title) {
    super(title);
  }

  @Override
  String text() {
    return title();
  }
}

class Correction extends Message {
  Correction(String title, String reason) {
    super(title);
  }

  @Override
  String text() {
    return "OPRAVA: " + title();
  }
}
// UPRAVUJ POTUD
