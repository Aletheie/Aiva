import java.util.Scanner;

public class Main {
    static String reverse(String text, int index) {
        // TODO: základní případ a jeden menší podproblém.
        return text;
    }

    public static void main(String[] args) {
        String message = new Scanner(System.in).nextLine();
        System.out.println(reverse(message, message.length() - 1));
    }
}
