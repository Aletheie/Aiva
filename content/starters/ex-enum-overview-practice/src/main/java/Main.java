enum TaskStatus {
    TODO("Čeká"),
    ACTIVE("Probíhá"),
    DONE("Hotovo");

    private final String label;

    TaskStatus(String label) {
        this.label = label;
    }

    public String label() {
        return label;
    }
}

public class Main {
    public static void main(String[] args) {
        TaskStatus status = TaskStatus.ACTIVE;
        System.out.println(status.label()); // Probíhá
        System.out.println(status == TaskStatus.DONE); // false
        int remaining = switch (status) {
            case TODO -> 2;
            case ACTIVE -> 1;
            case DONE -> 0;
        };
        System.out.println(remaining); // 1
    }
}
