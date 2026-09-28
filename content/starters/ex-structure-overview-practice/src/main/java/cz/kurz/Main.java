package cz.kurz;

import cz.kurz.model.Task;
import cz.kurz.service.TaskService;
import java.util.List;

public class Main {
    public static void main(String[] args) {
        List<Task> tasks = List.of(new Task("Java", false), new Task("Git", true));
        TaskService service = new TaskService();
        System.out.println(service.countOpen(tasks)); // 1
    }
}
