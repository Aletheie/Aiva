package org.aiva.studydesk;
import org.aiva.studydesk.service.TaskService;
import org.aiva.studydesk.repository.InMemoryTaskRepository;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
class TaskServiceTest {
    @Test void addsTaskAndPreservesItAcrossServices() throws Exception {
        var repository = new InMemoryTaskRepository();
        var service = new TaskService(repository);
        var task = service.add("Pochopit reference");
        assertEquals("Pochopit reference", new TaskService(repository).list().getFirst().title());
        assertFalse(task.completed());
    }
    @Test void rejectsBlankTitleWithoutChangingState() throws Exception {
        var service = new TaskService(new InMemoryTaskRepository());
        assertThrows(IllegalArgumentException.class, () -> service.add("   "));
        assertTrue(service.list().isEmpty());
    }
    @Test void exposesImmutableList() throws Exception {
        var service = new TaskService(new InMemoryTaskRepository());
        assertThrows(UnsupportedOperationException.class, () -> service.list().clear());
    }
}
