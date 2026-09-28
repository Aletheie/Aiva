import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class BillSplitTest {
  @Test
  void divisibleBill() {
    assertArrayEquals(new int[] {50, 50}, BillSplit.shares(100, 2));
  }

  @Test
  void remainderGoesToFirstGuests() {
    assertArrayEquals(new int[] {34, 34, 33}, BillSplit.shares(101, 3));
  }

  @Test
  void lessCentsThanGuests() {
    assertArrayEquals(new int[] {1, 1, 0, 0}, BillSplit.shares(2, 4));
  }

  @Test
  void zeroBillStillHasEveryGuest() {
    assertArrayEquals(new int[] {0, 0, 0}, BillSplit.shares(0, 3));
  }

  @Test
  void singleGuestAndMaximumGroup() {
    assertArrayEquals(new int[] {101}, BillSplit.shares(101, 1));
    assertArrayEquals(new int[] {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, BillSplit.shares(12, 12));
  }

  @Test
  void invalidInputs() {
    assertThrows(IllegalArgumentException.class, () -> BillSplit.shares(-1, 2));
    assertThrows(IllegalArgumentException.class, () -> BillSplit.shares(10, 0));
    assertThrows(IllegalArgumentException.class, () -> BillSplit.shares(10, 13));
  }
}
