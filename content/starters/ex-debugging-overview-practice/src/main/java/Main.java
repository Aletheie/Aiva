public class Main {
    static int total(int[] values) {
        int sum = 0;
        for (int i = 0; i < values.length; i++) {
            sum += values[i];
        }
        return sum;
    }

    public static void main(String[] args) {
        int[] values = {4, 7, 9};
        System.out.println(total(values)); // 20
    }
}
