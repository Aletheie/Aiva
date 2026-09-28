class Animal {
    private final String name;

    public Animal(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public String sound() {
        return "ticho";
    }
}

class Dog extends Animal {
    public Dog(String name) {
        super(name);
    }

    @Override
    public String sound() {
        return "haf";
    }
}

public class Main {
    public static void main(String[] args) {
        Dog dog = new Dog("Bety");
        System.out.println(dog.getName() + ": " + dog.sound());
    }
}
