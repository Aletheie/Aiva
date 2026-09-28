import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Scanner;

public class Main {
    record Guest(String name, int dances) {}

    static List<Guest> ordered(List<Guest> original) {
        // TODO: seřaď samostatnou kopii podle dvou pravidel.
        return original;
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int count = Integer.parseInt(input.nextLine());
        List<Guest> guests = new ArrayList<>();
        for (int i = 0; i < count; i++) {
            String[] parts = input.nextLine().split(";", -1);
            guests.add(new Guest(parts[0], Integer.parseInt(parts[1])));
        }
        for (Guest guest : ordered(guests)) System.out.println(guest.name() + ": " + guest.dances());
        System.out.println("Puvodni prvni: " + (guests.isEmpty() ? "-" : guests.get(0).name()));
    }
}
