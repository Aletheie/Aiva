import java.util.Objects;

final class TicketCode {
    private final String value;

    public TicketCode(String value) {
        this.value = Objects.requireNonNull(value, "Kód chybí");
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof TicketCode code)) {
            return false;
        }
        return value.equals(code.value);
    }

    @Override
    public int hashCode() {
        return value.hashCode();
    }

    @Override
    public String toString() {
        return "TicketCode[" + value + "]";
    }
}

public class Main {
    public static void main(String[] args) {
        TicketCode first = new TicketCode("A7");
        TicketCode second = new TicketCode("A7");
        System.out.println(first == second);      // false
        System.out.println(first.equals(second)); // true
        System.out.println(first);                // TicketCode[A7]
    }
}
