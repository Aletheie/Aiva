class Seats {
    private int available;

    public Seats(int available) {
        if (available < 0) {
            throw new IllegalArgumentException("Záporný počet míst");
        }
        this.available = available;
    }

    public int getAvailable() {
        return available;
    }

    public boolean reserve() {
        if (available == 0) {
            return false;
        }
        available--;
        return true;
    }
}

public class Main {
    public static void main(String[] args) {
        Seats seats = new Seats(1);
        System.out.println(seats.reserve());      // true
        System.out.println(seats.reserve());      // false
        System.out.println(seats.getAvailable()); // 0
    }
}
