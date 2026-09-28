import java.util.Scanner;

public class Main {
    static int firstIndex(int[] codes, int wanted) {
        // TODO: půl hledaného intervalu v každém kroku vyřaď.
        return -1;
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int[] codes = new int[input.nextInt()];
        for (int i = 0; i < codes.length; i++) codes[i] = input.nextInt();
        System.out.println(firstIndex(codes, input.nextInt()));
    }
}
