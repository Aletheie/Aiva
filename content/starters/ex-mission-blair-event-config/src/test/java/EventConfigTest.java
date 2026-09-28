import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.yaml.snakeyaml.error.YAMLException;

class EventConfigTest {
  @Test
  void acceptsTypedValues() {
    assertEquals(
        new EventConfig.Config(40, true, "Blair"),
        EventConfig.read("capacity: 40\nreminders: true\nhost: ' Blair '\nextra: ignored"));
  }

  @Test
  void boundaries() {
    for (int n : new int[] {1, 200})
      assertEquals(
          n, EventConfig.read("capacity: " + n + "\nreminders: false\nhost: Serena").capacity());
  }

  @Test
  void refusesStringNumbersAndBooleans() {
    for (String yaml :
        new String[] {
          "capacity: '40'\nreminders: true\nhost: Blair",
          "capacity: 40\nreminders: 'false'\nhost: Blair"
        }) assertThrows(IllegalArgumentException.class, () -> EventConfig.read(yaml));
  }

  @Test
  void rejectsMissingAndOutOfRange() {
    for (String yaml :
        new String[] {
          "{}",
          "[]",
          "capacity: 0\nreminders: true\nhost: Blair",
          "capacity: 201\nreminders: true\nhost: Blair",
          "capacity: 4.5\nreminders: true\nhost: Blair",
          "capacity: 40\nreminders: true\nhost: ' '"
        }) assertThrows(IllegalArgumentException.class, () -> EventConfig.read(yaml));
  }

  @Test
  void duplicateKeysStayRejected() {
    assertThrows(
        YAMLException.class,
        () -> EventConfig.read("capacity: 40\ncapacity: 80\nreminders: true\nhost: Blair"));
  }
}
