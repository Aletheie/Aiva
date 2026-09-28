import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int people = Integer.parseInt(input.nextLine());
        int capacity = 100;
        if (people < capacity) {
            System.out.println("Volno: " + (capacity - people));
        } else if (people == capacity) {
            System.out.println("Vyprodano");
        } else {
            System.out.println("Chybi: " + (people - capacity));
        }
    }
}
