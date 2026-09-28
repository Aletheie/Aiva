package org.aiva.studydesk.repository;
import org.aiva.studydesk.domain.Task;
import java.util.List;
public final class InMemoryTaskRepository implements TaskRepository {
    private List<Task> tasks = List.of();
    public List<Task> load() { return tasks; }
    public void save(List<Task> values) { tasks = List.copyOf(values); }
}
