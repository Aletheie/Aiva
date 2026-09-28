import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

class ShippingTest {
    @Test
    void freeAtThreshold() {
        Shipping shipping = new Shipping(); // Arrange
        int actual = shipping.cost(1000);   // Act
        assertEquals(0, actual);            // Assert
    }

    @Test
    void rejectsNegativeTotal() {
        Shipping shipping = new Shipping();
        assertThrows(IllegalArgumentException.class, () -> shipping.cost(-1));
    }
}
