import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class Main {
    record Journey(List<String> stops) {
        Journey {
            stops = List.copyOf(stops);
        }
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int count = Integer.parseInt(input.nextLine());
        List<String> draft = new ArrayList<>();
        for (int i = 0; i < count; i++) draft.add(input.nextLine());
        Journey approved = new Journey(draft);
        String extra = input.nextLine();
        draft.add(extra);
        Journey revised = new Journey(draft);
        System.out.println("Schvaleno: " + approved.stops());
        System.out.println("Novy navrh: " + revised.stops());
    }
}
