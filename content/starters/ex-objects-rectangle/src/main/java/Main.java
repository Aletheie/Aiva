import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int width = Integer.parseInt(input.nextLine());
        int height = Integer.parseInt(input.nextLine());
        Rectangle rectangle = new Rectangle(width, height);
        System.out.println(rectangle.area());
        System.out.println(rectangle.perimeter());
    }
}
