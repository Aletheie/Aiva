import java.util.*;
public class Main {
    public static void main(String[] args) {
        Map<String, Contact> contacts = new LinkedHashMap<>();
        contacts.put("Eva Nová", new Contact("Eva Nová", "eva@example.invalid"));
        System.out.println(contacts.get("Eva Nová"));
    }
}
