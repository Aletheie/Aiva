public class Main {
    public static void main(String[] args) {
        int first = 5;
        int second = 4;
        int third = 5;
        int fourth = 4;
        int votes = 4;
        int total = first + second + third + fourth;
        double average = (double) total / votes;
        double percent = average / 5 * 100;
        System.out.println("Prumer: " + average);
        System.out.println("Procent: " + percent);
    }
}
