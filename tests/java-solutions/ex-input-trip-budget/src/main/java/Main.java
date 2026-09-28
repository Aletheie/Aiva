import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int people = Integer.parseInt(input.nextLine().trim());
        int ticket = Integer.parseInt(input.nextLine().trim());
        int transport = Integer.parseInt(input.nextLine().trim());
        int total = people * ticket + transport;
        double share = (double) total / people;
        System.out.println("Celkem: " + total);
        System.out.println("Na osobu: " + share);
    }
}
