import java.util.Scanner;

public class Main {
    static String findPair(int[][] seats) {
        // TODO: najdi první dvě sousední nuly v téže řadě.
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
