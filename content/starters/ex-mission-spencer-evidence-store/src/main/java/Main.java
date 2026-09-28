import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    String mode = in.next();
    int n = in.nextInt();
    Map<String, Entry> rows = new HashMap<>();
    for (int i = 0; i < n; i++) {
      String id = in.next();
      rows.put(id, new Entry(id, in.nextBoolean()));
    }
    EvidenceStore store = mode.equals("MEMORY") ? new MemoryStore(rows) : new EmptyStore();
    int q = in.nextInt();
    String[] ids = new String[q];
    for (int i = 0; i < q; i++) ids[i] = in.next();
    Report.print(ids, store);
  }
}

record Entry(String id, boolean verified) {}

interface EvidenceStore {
  Entry find(String id);
}

class MemoryStore implements EvidenceStore {
  private final Map<String, Entry> entries;

  MemoryStore(Map<String, Entry> entries) {
    this.entries = entries;
  }

  public Entry find(String id) {
    return entries.get(id);
  }
}

class EmptyStore implements EvidenceStore {
  public Entry find(String id) {
    return null;
  }
}

class Report {
  // UPRAVUJ ODSUD
  static void print(String[] ids, EvidenceStore store) {
    for (String id : ids) System.out.println(id + ":" + store.find(id).verified());
    System.out.println("Potvrzene: " + ids.length);
  }
  // UPRAVUJ POTUD
}
