import java.util.Scanner;
public class Main {
    public static void main(String[] args) {
        int secret = 42;
        Scanner input = new Scanner(System.in);
        System.out.println("Zadej jeden tip:");
        int guess = input.nextInt();
        System.out.println(guess == secret ? "Správně" : "Zatím ne");
        // Rozšiř tuto fungující jednokolovou verzi podle PROJECT.md.
    }
}
