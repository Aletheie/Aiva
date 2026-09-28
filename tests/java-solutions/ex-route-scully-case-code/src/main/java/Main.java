import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Main {
    private static final Pattern CODE = Pattern.compile("([A-Z]{2})-([0-9]{3})");

    public static void main(String[] args) {
        String line = new Scanner(System.in).nextLine();
        Matcher matcher = CODE.matcher(line);
        if (matcher.matches()) {
            System.out.println("Oddeleni: " + matcher.group(1));
            System.out.println("Spis: " + matcher.group(2));
        } else {
            System.out.println("Neplatny kod");
        }
    }
}
