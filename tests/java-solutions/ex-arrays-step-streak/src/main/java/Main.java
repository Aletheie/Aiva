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
        int total = 0;
        int completed = 0;
        int streak = 0;
        int longest = 0;
        for (int value : steps) {
            total += value;
            if (value >= 6000) {
                completed++;
                streak++;
                if (streak > longest) {
                    longest = streak;
                }
            } else {
                streak = 0;
            }
        }
        System.out.println("Celkem: " + total);
        System.out.println("Splneno: " + completed);
        System.out.println("Serie: " + longest);
    }
}
