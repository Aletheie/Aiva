public class Main {
    public static void main(String[] args) {
        int price = 180;
        int count = 3;
        int coupon = 80;
        int paid = 1000;
        count = 4;
        int total = price * count - coupon;
        int change = paid - total;
        System.out.println("Listky: " + count);
        System.out.println("K zaplaceni: " + total);
        System.out.println("Vratit: " + change);
    }
}
