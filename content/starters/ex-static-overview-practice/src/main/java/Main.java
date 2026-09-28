class Ticket {
    public static final int MAX_SEATS = 30;
    private static int issued = 0;
    private final String owner;

    public Ticket(String owner) {
        this.owner = owner;
        issued++;
    }

    public String getOwner() {
        return owner;
    }

    public static int getIssued() {
        return issued;
    }
}

public class Main {
    public static void main(String[] args) {
        Ticket first = new Ticket("Ada");
        Ticket second = new Ticket("Eva");
        System.out.println(first.getOwner());  // Ada
        System.out.println(second.getOwner()); // Eva
        System.out.println(Ticket.getIssued()); // 2
        System.out.println(Ticket.MAX_SEATS);   // 30
    }
}
