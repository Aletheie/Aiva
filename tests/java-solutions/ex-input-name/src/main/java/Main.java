import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int age = Integer.parseInt(input.nextLine());
        String name = input.nextLine();
        System.out.println("Jmeno: " + name);
        System.out.println(age);
    }
}
