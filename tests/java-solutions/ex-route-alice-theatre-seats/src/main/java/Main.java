import java.util.Scanner;

public class Main {
    static String findPair(int[][] seats) {
        for (int row = 0; row < seats.length; row++) {
            for (int col = 0; col + 1 < seats[row].length; col++) {
                if (seats[row][col] == 0 && seats[row][col + 1] == 0) {
                    return "Rada " + (row + 1) + ", sedadla " + (col + 1) + " a " + (col + 2);
                }
            }
        }
        return "Plno";
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int[][] seats = new int[input.nextInt()][];
        for (int row = 0; row < seats.length; row++) {
            seats[row] = new int[input.nextInt()];
            for (int col = 0; col < seats[row].length; col++) seats[row][col] = input.nextInt();
        }
        System.out.println(findPair(seats));
    }
}
