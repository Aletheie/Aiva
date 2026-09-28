public class Main {
    static int readAge(String text) {
        int age = Integer.parseInt(text);
        if (age < 0) {
            throw new IllegalArgumentException("Věk nesmí být záporný");
        }
        return age;
    }

    public static void main(String[] args) {
        String[] inputs = {"18", "ahoj", "-2"};
        for (String input : inputs) {
            try {
                System.out.println(readAge(input));
            } catch (NumberFormatException error) {
                System.out.println("Zadej celé číslo");
            } catch (IllegalArgumentException error) {
                System.out.println(error.getMessage());
            } finally {
                System.out.println("Pokus dokončen");
            }
        }
    }
}
