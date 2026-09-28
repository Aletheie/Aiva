import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int count = Integer.parseInt(input.nextLine());
        int[] steps = new int[count];
        for (int i = 0; i < steps.length; i++) {
            steps[i] = Integer.parseInt(input.nextLine());
        }
        printSummary(steps);
    }
    static void printSummary(int[] steps) {
        // Sečti kroky a sleduj splněné dny i sérii jdoucí po sobě.
    }
}
