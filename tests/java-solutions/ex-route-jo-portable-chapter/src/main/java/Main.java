public class Main {
    public static void main(String[] args) {
        if (args.length != 1 || args[0].isBlank()) {
            System.out.println("Pouziti: java -jar little-women.jar \"Nazev kapitoly\"");
            return;
        }
        System.out.println("Jo tiskne: " + args[0].strip());
    }
}
