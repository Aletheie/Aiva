import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int price = Integer.parseInt(input.nextLine());
        int paid = 0;
        while (paid < price) {
            int payment = Integer.parseInt(input.nextLine());
            paid = paid + payment;
            if (paid < price) {
                System.out.println("Zbyva: " + (price - paid));
            }
        }
        System.out.println("Vratit: " + (paid - price));
    }
}
