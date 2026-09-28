interface NameRepository {
    String findName(int id);
}

class GreetingService {
    private final NameRepository repository;

    GreetingService(NameRepository repository) {
        this.repository = repository;
    }

    String greet(int id) {
        String name = repository.findName(id);
        return name == null ? "Ahoj, hoste" : "Ahoj, " + name;
    }
}

public class Main {
    public static void main(String[] args) {
        NameRepository stub = id -> "Ada";
        GreetingService service = new GreetingService(stub);
        System.out.println(service.greet(7)); // Ahoj, Ada
    }
}
