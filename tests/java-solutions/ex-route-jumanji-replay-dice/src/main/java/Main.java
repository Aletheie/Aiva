import java.util.Random;
import java.util.Scanner;

public class Main {
    static int roll(Random random) {
        return random.nextInt(6) + 1;
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        long seed = input.nextLong();
        int count = input.nextInt();
        Random random = new Random(seed);
        int sum = 0;
        for (int i = 0; i < count; i++) {
            int value = roll(random);
            System.out.println("Hod: " + value);
            sum += value;
        }
        System.out.println("Soucet: " + sum);
    }
}
