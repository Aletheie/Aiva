import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    int n = in.nextInt();
    TestNotifier notifier = new TestNotifier();
    SentIds sent = new SentIds();
    for (int i = 0; i < n; i++) {
      String id = in.next();
      notifier.ready = in.nextBoolean();
      System.out.println(Delivery.deliver(id, "Hlaseni", notifier, sent));
    }
    System.out.println("Pokusy: " + notifier.calls);
    System.out.println("Ulozeno: " + sent.size());
  }
}

interface Notifier {
  boolean send(String id, String message);
}

class TestNotifier implements Notifier {
  boolean ready;
  int calls;

  public boolean send(String id, String message) {
    calls++;
    return ready;
  }
}

class SentIds {
  private final Set<String> values = new HashSet<>();

  boolean has(String id) {
    return values.contains(id);
  }

  void remember(String id) {
    values.add(id);
  }

  int size() {
    return values.size();
  }
}

class Delivery {
  // UPRAVUJ ODSUD
  static String deliver(String id, String message, Notifier notifier, SentIds sent) {
    if (sent.has(id)) return "UZ ODESLANO";
    if (!notifier.send(id, message)) return "CHYBA";
    sent.remember(id);
    return "ODESLANO";
  }
  // UPRAVUJ POTUD
}
