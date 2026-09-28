package org.aiva.studydesk.service;
import org.aiva.studydesk.domain.Task;
import org.aiva.studydesk.repository.TaskRepository;
import java.io.IOException;
import java.util.*;
public final class TaskService {
    private final TaskRepository repository;
    private List<Task> tasks;
    public TaskService(TaskRepository repository) throws IOException {
        this.repository = Objects.requireNonNull(repository);
        this.tasks = List.copyOf(repository.load());
    }
    public List<Task> list() { return tasks; }
    public Task add(String title) throws IOException {
        Task added = Task.create(title);
        List<Task> changed = new ArrayList<>(tasks); changed.add(added);
        repository.save(changed); // Commit in-memory state only after successful save.
        tasks = List.copyOf(changed);
        return added;
    }
}
