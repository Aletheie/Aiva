import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class EvidenceReaderTest {
  @Test
  void keepsIdentifierAndTrims() {
    assertEquals(
        new EvidenceReader.Evidence("007", "Žlutý lístek", 80),
        EvidenceReader.read(
            "{\"id\":\" 007 \",\"label\":\" Žlutý lístek \",\"confidence\":80,\"extra\":true}"));
  }

  @Test
  void acceptsBoundaries() {
    for (int n : new int[] {0, 100})
      assertEquals(
          n,
          EvidenceReader.read("{\"id\":\"x\",\"label\":\"y\",\"confidence\":" + n + "}")
              .confidence());
  }

  @Test
  void rejectsTypesAndMissingFields() {
    for (String json :
        new String[] {
          "[]",
          "null",
          "{}",
          "{\"id\":7,\"label\":\"x\",\"confidence\":1}",
          "{\"id\":\"x\",\"label\":null,\"confidence\":1}",
          "{\"id\":\"x\",\"label\":\" \",\"confidence\":1}",
          "{\"id\":\"x\",\"label\":\"y\",\"confidence\":\"80\"}"
        }) assertThrows(IllegalArgumentException.class, () -> EvidenceReader.read(json), json);
  }

  @Test
  void rejectsInvalidNumbers() {
    for (String n : new String[] {"-1", "101", "2.5", "999999999999999999999999"})
      assertThrows(
          IllegalArgumentException.class,
          () -> EvidenceReader.read("{\"id\":\"x\",\"label\":\"y\",\"confidence\":" + n + "}"),
          n);
  }

  @Test
  void rejectsBrokenSyntax() {
    assertThrows(IllegalArgumentException.class, () -> EvidenceReader.read("{broken"));
  }

  @Test
  void rejectsBlankIdentifier() {
    assertThrows(
        IllegalArgumentException.class,
        () -> EvidenceReader.read("{\"id\":\" \",\"label\":\"note\",\"confidence\":80}"));
  }
}
