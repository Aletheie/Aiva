import java.util.Scanner;

public class Main {
    static int firstIndex(int[] codes, int wanted) {
        int low = 0;
        int high = codes.length - 1;
        int found = -1;
        while (low <= high) {
            int middle = low + (high - low) / 2;
            if (codes[middle] >= wanted) {
                if (codes[middle] == wanted) found = middle;
                high = middle - 1;
            } else {
                low = middle + 1;
            }
        }
        return found;
    }

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int[] codes = new int[input.nextInt()];
        for (int i = 0; i < codes.length; i++) codes[i] = input.nextInt();
        System.out.println(firstIndex(codes, input.nextInt()));
    }
}
