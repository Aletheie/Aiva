package cz.kurz.service;

import cz.kurz.model.Task;
import java.util.List;

public class TaskService {
    public long countOpen(List<Task> tasks) {
        return tasks.stream().filter(task -> !task.done()).count();
    }
}
