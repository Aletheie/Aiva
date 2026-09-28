import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class CancellationTest {
  @Test
  void exactly48HoursIsFree() {
    assertEquals(0, Cancellation.fee(101, 48));
  }

  @Test
  void earlierIsFree() {
    assertEquals(0, Cancellation.fee(101, 49));
  }

  @Test
  void exactly24HoursIsQuarter() {
    assertEquals(26, Cancellation.fee(101, 24));
  }

  @Test
  void justBelow48IsQuarter() {
    assertEquals(26, Cancellation.fee(101, 47));
  }

  @Test
  void justBelow24AndNowCostFullPrice() {
    assertEquals(101, Cancellation.fee(101, 23));
    assertEquals(101, Cancellation.fee(101, 0));
  }

  @Test
  void roundingAndZero() {
    assertEquals(1, Cancellation.fee(1, 30));
    assertEquals(2, Cancellation.fee(5, 30));
    assertEquals(25, Cancellation.fee(100, 30));
    assertEquals(0, Cancellation.fee(0, 30));
  }

  @Test
  void invalidArguments() {
    assertThrows(IllegalArgumentException.class, () -> Cancellation.fee(-1, 50));
    assertThrows(IllegalArgumentException.class, () -> Cancellation.fee(100001, 50));
    assertThrows(IllegalArgumentException.class, () -> Cancellation.fee(100, -1));
  }
}
