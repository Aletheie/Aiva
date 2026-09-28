import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int age = input.nextInt();
        String name = input.nextLine();
        System.out.println("Jmeno: " + name);
        System.out.println(age);
    }
}
