import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class Main {
    static int distressCalls(String message) {
        int count = 0;
        for (int i = 0; i < message.length(); i++) if (message.charAt(i) == '!') count++;
        return count;
    }

    static int collect(ExecutorService executor, List<String> messages)
            throws InterruptedException, ExecutionException {
        List<Future<Integer>> tasks = new ArrayList<>();
        for (String message : messages) tasks.add(executor.submit(() -> distressCalls(message)));
        int total = 0;
        for (Future<Integer> task : tasks) total += task.get();
        return total;
    }

    public static void main(String[] args) throws Exception {
        Scanner input = new Scanner(System.in);
        int count = Integer.parseInt(input.nextLine());
        List<String> messages = new ArrayList<>();
        for (int i = 0; i < count; i++) messages.add(input.nextLine());
        try (ExecutorService executor = Executors.newVirtualThreadPerTaskExecutor()) {
            System.out.println("Volani o pomoc: " + collect(executor, messages));
        }
    }
}
