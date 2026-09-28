interface Notifier {
    void send(String message);

    default void welcome() {
        send("Vítej v kurzu");
    }
}

class ConsoleNotifier implements Notifier {
    @Override
    public void send(String message) {
        System.out.println(message);
    }
}

class CourseService {
    private final Notifier notifier;

    public CourseService(Notifier notifier) {
        this.notifier = notifier;
    }

    public void finishLesson() {
        notifier.send("Lekce dokončena");
    }
}

public class Main {
    public static void main(String[] args) {
        Notifier notifier = new ConsoleNotifier();
        notifier.welcome();
        CourseService service = new CourseService(notifier);
        service.finishLesson();
    }
}
