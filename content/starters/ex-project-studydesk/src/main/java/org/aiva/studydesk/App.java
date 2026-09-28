package org.aiva.studydesk;
import org.aiva.studydesk.repository.JsonTaskRepository;
import org.aiva.studydesk.service.TaskService;
import java.io.IOException;
import java.nio.file.Path;
import java.util.Scanner;
public final class App {
    public static void main(String[] args) {
        try {
            TaskService service = new TaskService(new JsonTaskRepository(Path.of("data", "tasks.json")));
            Scanner console = new Scanner(System.in);
            System.out.println("StudyDesk: add NÁZEV, list, quit. Změny se ihned ukládají.");
            while (console.hasNextLine()) {
                String command = console.nextLine();
                if (command.equals("quit")) return;
                try {
                    if (command.equals("list")) service.list().forEach(task ->
                        System.out.println(task.id() + " [" + (task.completed() ? "x" : " ") + "] " + task.title()));
                    else if (command.startsWith("add ")) System.out.println("Přidáno: " + service.add(command.substring(4)).id());
                    else System.out.println("Neznámý příkaz. Použij add NÁZEV, list nebo quit.");
                } catch (IOException | IllegalArgumentException failure) {
                    System.err.println("Operace se nezdařila: " + failure.getMessage());
                }
            }
        } catch (IOException failure) {
            System.err.println("Data se nepodařilo načíst. Nebudou přepsána: " + failure.getMessage());
            System.exit(1);
        }
    }
}
