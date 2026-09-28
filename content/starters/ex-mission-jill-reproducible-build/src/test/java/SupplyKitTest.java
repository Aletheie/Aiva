import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class SupplyKitTest {
  @Test
  void bottleneckLimitsTeams() {
    assertEquals(2, new SupplyKit(8, 7).completeTeams());
    assertEquals(1, new SupplyKit(3, 30).completeTeams());
    assertEquals(0, new SupplyKit(0, 9).completeTeams());
  }

  @Test
  void invalidStockFails() {
    assertThrows(IllegalArgumentException.class, () -> new SupplyKit(-1, 3));
    assertThrows(IllegalArgumentException.class, () -> new SupplyKit(1, -3));
  }
}
