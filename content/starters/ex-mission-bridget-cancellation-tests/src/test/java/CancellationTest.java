import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class CancellationTest {
  // UPRAVUJ ODSUD
  @Test
  void usualCancellation() {
    assertEquals(25, Cancellation.fee(100, 30));
  }
  // UPRAVUJ POTUD
}
