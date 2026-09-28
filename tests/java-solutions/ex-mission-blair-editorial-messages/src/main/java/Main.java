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
    return "NOVY: " + title();
  }
}

class Correction extends Message {
  private final String reason;

  Correction(String title, String reason) {
    super(title);
    this.reason = reason.trim();
  }

  @Override
  String text() {
    return reason.isEmpty() ? "NEUPLNA OPRAVA: " + title() : "OPRAVA: " + title() + " / " + reason;
  }
}
// UPRAVUJ POTUD
