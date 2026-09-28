import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    RoomRepository repo = new RoomRepository();
    RoomService service = new RoomService(repo);
    int n = Integer.parseInt(in.nextLine());
    for (int i = 0; i < n; i++) {
      String name = in.nextLine(), room = in.nextLine();
      repo.failNext = Boolean.parseBoolean(in.nextLine());
      System.out.println(service.move(name, room));
      service.snapshot().clear();
      System.out.println("App: " + service.snapshot());
      System.out.println("Disk: " + repo.snapshot());
    }
    System.out.println("Zapisy: " + repo.calls);
  }
}

class RoomRepository {
  private Map<String, String> saved = new LinkedHashMap<>();
  boolean failNext = false;
  int calls = 0;

  void save(Map<String, String> candidate) throws java.io.IOException {
    calls++;
    if (failNext) {
      failNext = false;
      throw new java.io.IOException("offline");
    }
    saved = new LinkedHashMap<>(candidate);
  }

  Map<String, String> snapshot() {
    return new LinkedHashMap<>(saved);
  }
}

class RoomService {
  // UPRAVUJ ODSUD
  private final RoomRepository repo;
  private Map<String, String> rooms = new LinkedHashMap<>();

  RoomService(RoomRepository repo) {
    this.repo = repo;
  }

  String move(String name, String room) {
    rooms.put(name, room);
    try {
      repo.save(rooms);
    } catch (java.io.IOException e) {
    }
    return "SAVED";
  }

  Map<String, String> snapshot() {
    return rooms;
  }
  // UPRAVUJ POTUD
}
