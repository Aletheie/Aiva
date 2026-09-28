import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        int year = Integer.parseInt(input.nextLine());
        boolean leap = year % 400 == 0 || (year % 4 == 0 && year % 100 != 0);
        System.out.println(leap);
    }
}
