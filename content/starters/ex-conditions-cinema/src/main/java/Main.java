import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int people = Integer.parseInt(input.nextLine());
        int capacity = 100;
        if (people <= capacity) {
            System.out.println("Volno: " + (capacity - people));
        }
        if (people >= capacity) {
            System.out.println("Chybi: " + (capacity - people));
        } else {
            System.out.println("Vyprodano");
        }
    }
}
