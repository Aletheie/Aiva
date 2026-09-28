import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        String departureText = input.nextLine();
        String todayText = input.nextLine();
        int days = Integer.parseInt(input.nextLine());
        try {
            LocalDate departure = LocalDate.parse(departureText);
            LocalDate today = LocalDate.parse(todayText);
            LocalDate arrival = departure.plusDays(days);
            long remaining = ChronoUnit.DAYS.between(today, arrival);
            System.out.println("Navrat: " + arrival);
            if (remaining >= 0) System.out.println("Zbyva: " + remaining);
            else System.out.println("Zpozdeni: " + (-remaining));
        } catch (DateTimeParseException error) {
            System.out.println("Neplatne datum");
        }
    }
}
