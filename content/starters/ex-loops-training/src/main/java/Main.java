import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int rounds = Integer.parseInt(input.nextLine());
        int total = 0;
        for (int round = 1; round < rounds; round++) {
            int seconds = 20 + (round - 1) * 5;
            System.out.println("Kolo " + round + ": " + seconds + " s");
            total = total + seconds;
            System.out.println("Pauza: 30 s");
            total = total + 30;
        }
        System.out.println("Celkem: " + total + " s");
    }
}
