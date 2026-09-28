import java.util.Arrays;
import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int count = Integer.parseInt(input.nextLine());
        int[] source = new int[count];
        for (int i = 0; i < source.length; i++) {
            source[i] = Integer.parseInt(input.nextLine());
        }
        int[] preview = incrementedCopy(source);
        System.out.println("Puvodni: " + Arrays.toString(source));
        System.out.println("Nahled: " + Arrays.toString(preview));
        System.out.println("Stejne pole: " + (source == preview));
    }
    static int[] incrementedCopy(int[] values) {
        int[] copy = new int[values.length];
        for (int i = 0; i < values.length; i++) {
            copy[i] = values[i] + 1;
        }
        return copy;
    }
}
