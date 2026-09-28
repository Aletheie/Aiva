public class Shipping {
    public int cost(int orderTotal) {
        if (orderTotal < 0) {
            throw new IllegalArgumentException("Záporná objednávka");
        }
        return orderTotal >= 1000 ? 0 : 79;
    }
}
