import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        String command = input.nextLine();
        command.trim();
        boolean accepted = command == "start";
        System.out.println(command);
        System.out.println(accepted);
    }
}
