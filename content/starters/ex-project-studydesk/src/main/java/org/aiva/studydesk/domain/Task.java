package org.aiva.studydesk.domain;
import java.util.UUID;
public record Task(String id, String title, boolean completed) {
    public Task {
        UUID.fromString(id);
        if (title == null || title.isBlank() || title.length() > 200)
            throw new IllegalArgumentException("Název musí mít 1–200 znaků");
        title = title.strip();
    }
    public static Task create(String title) { return new Task(UUID.randomUUID().toString(), title, false); }
}
