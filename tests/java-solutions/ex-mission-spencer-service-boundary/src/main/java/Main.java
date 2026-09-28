import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    EvidenceRepository repo = new EvidenceRepository();
    EvidenceService service = new EvidenceService(repo);
    int n = Integer.parseInt(in.nextLine());
    for (int i = 0; i < n; i++) System.out.println(service.register(in.nextLine(), in.nextLine()));
    for (Evidence e : repo.all()) System.out.println(e.id() + ":" + e.note());
    System.out.println("Pristupy: " + repo.reads + "/" + repo.writes);
  }
}

enum Result {
  ADDED,
  DUPLICATE,
  INVALID
}

record Evidence(String id, String note) {}

class EvidenceRepository {
  private final Map<String, Evidence> entries = new LinkedHashMap<>();
  int reads = 0, writes = 0;

  boolean contains(String id) {
    reads++;
    return entries.containsKey(id);
  }

  void save(Evidence e) {
    writes++;
    entries.put(e.id(), e);
  }

  Collection<Evidence> all() {
    return entries.values();
  }
}

class EvidenceService {
  // UPRAVUJ ODSUD
  private final EvidenceRepository repo;

  EvidenceService(EvidenceRepository repo) {
    this.repo = repo;
  }

  Result register(String rawId, String rawNote) {
    String id = rawId.trim().toUpperCase(Locale.ROOT), note = rawNote.trim();
    if (id.isEmpty() || note.isEmpty()) return Result.INVALID;
    if (repo.contains(id)) return Result.DUPLICATE;
    repo.save(new Evidence(id, note));
    return Result.ADDED;
  }
  // UPRAVUJ POTUD
}
