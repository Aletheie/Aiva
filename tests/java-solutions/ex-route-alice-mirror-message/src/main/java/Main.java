import java.util.Scanner;

public class Main {
    static String reverse(String text, int index) {
        if (index < 0) return "";
        return text.charAt(index) + reverse(text, index - 1);
    }

    public static void main(String[] args) {
        String message = new Scanner(System.in).nextLine();
        System.out.println(reverse(message, message.length() - 1));
    }
}
