class Box<T> {
    private T value;

    public Box(T value) {
        this.value = value;
    }

    public T get() {
        return value;
    }

    public void set(T value) {
        this.value = value;
    }
}

public class Main {
    public static void main(String[] args) {
        Box<String> name = new Box<>("Ada");
        name.set("Eva");
        String text = name.get();
        Box<Integer> count = new Box<>(3);
        int result = count.get() + 1;
        System.out.println(text);   // Eva
        System.out.println(result); // 4
    }
}
