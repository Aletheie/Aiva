public class Main {
    public static void main(String[] args) {
        Counter first = new Counter();
        Counter second = new Counter();
        first.increment();
        first.increment();
        second.increment();
        System.out.println(first.getValue());
        System.out.println(second.getValue());
        first.reset();
        System.out.println(first.getValue());
    }
}
