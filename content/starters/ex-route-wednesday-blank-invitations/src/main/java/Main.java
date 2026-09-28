import java.util.Scanner;

public class Main {
    static String guestName(String raw) {
        // TODO: chybějící hodnota nesmí shodit další pozvánky.
        return raw.strip();
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int count = Integer.parseInt(input.nextLine());
        for (int i = 0; i < count; i++) {
            String line = input.nextLine();
            String name = line.equals("@missing") ? null : line;
            System.out.println("Pozvanka: " + guestName(name));
        }
    }
}
