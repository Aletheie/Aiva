package cz.kurz.model;

public record Task(String title, boolean done) {
    public Task {
        if (title == null || title.isBlank()) {
            throw new IllegalArgumentException("Úkol potřebuje název");
        }
    }
}
