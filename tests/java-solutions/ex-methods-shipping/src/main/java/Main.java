import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int total = Integer.parseInt(input.nextLine());
        boolean pickup = Boolean.parseBoolean(input.nextLine());
        System.out.println(shipping(total, pickup));
    }
    static int shipping(int total, boolean pickup) {
        if (pickup || total >= 1000) {
            return 0;
        }
        return 79;
    }
}
