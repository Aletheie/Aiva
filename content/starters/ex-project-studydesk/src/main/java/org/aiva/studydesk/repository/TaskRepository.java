package org.aiva.studydesk.repository;
import org.aiva.studydesk.domain.Task;
import java.io.IOException;
import java.util.List;
public interface TaskRepository {
    List<Task> load() throws IOException;
    void save(List<Task> tasks) throws IOException;
}
