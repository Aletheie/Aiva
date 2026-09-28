package org.aiva.studydesk.repository;
import com.google.gson.*;
import org.aiva.studydesk.domain.Task;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.util.*;

/** Single-process storage. No interprocess locking and no crash-durability guarantee. */
public final class JsonTaskRepository implements TaskRepository {
    private final Path file;
    private final Gson gson = new GsonBuilder().setPrettyPrinting().create();
    public JsonTaskRepository(Path file) { this.file = file.toAbsolutePath().normalize(); }
    public List<Task> load() throws IOException {
        if (!Files.exists(file)) return List.of();
        if (Files.size(file) > 4 * 1024 * 1024) throw new IOException("Datový soubor překračuje limit 4 MiB");
        try {
            JsonObject root = JsonParser.parseString(Files.readString(file, StandardCharsets.UTF_8)).getAsJsonObject();
            if (!root.has("schemaVersion") || root.get("schemaVersion").getAsInt() != 1)
                throw new IllegalArgumentException("Neznámá verze dat");
            JsonArray rows = root.getAsJsonArray("tasks");
            if (rows == null) throw new IllegalArgumentException("Chybí tasks");
            List<Task> tasks = new ArrayList<>(); Set<String> ids = new HashSet<>();
            for (JsonElement element : rows) {
                JsonObject row = element.getAsJsonObject();
                Task task = new Task(row.get("id").getAsString(), row.get("title").getAsString(), row.get("completed").getAsBoolean());
                if (!ids.add(task.id())) throw new IllegalArgumentException("Duplicitní ID");
                tasks.add(task);
            }
            return List.copyOf(tasks);
        } catch (RuntimeException failure) { throw new IOException("Neplatný JSON; původní soubor zůstává beze změn", failure); }
    }
    public void save(List<Task> tasks) throws IOException {
        Files.createDirectories(file.getParent());
        JsonObject root = new JsonObject(); root.addProperty("schemaVersion", 1); root.add("tasks", gson.toJsonTree(tasks));
        Path temporary = Files.createTempFile(file.getParent(), ".studydesk-", ".json");
        try {
            Files.writeString(temporary, gson.toJson(root), StandardCharsets.UTF_8);
            try { Files.move(temporary, file, StandardCopyOption.ATOMIC_MOVE, StandardCopyOption.REPLACE_EXISTING); }
            catch (AtomicMoveNotSupportedException unavailable) {
                Files.move(temporary, file, StandardCopyOption.REPLACE_EXISTING);
            }
        } finally { Files.deleteIfExists(temporary); }
    }
}
