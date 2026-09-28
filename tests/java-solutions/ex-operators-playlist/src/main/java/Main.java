public class Main {
    public static void main(String[] args) {
        int first = 215;
        int second = 182;
        int third = 243;
        int pause = 30;
        int breakMinutes = 20;
        int total = first + second + third + 2 * pause;
        int remaining = breakMinutes * 60 - total;
        System.out.println("Playlist: " + total / 60 + " min " + total % 60 + " s");
        System.out.println("Zbyva: " + remaining / 60 + " min " + remaining % 60 + " s");
    }
}
