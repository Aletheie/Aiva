import static org.junit.jupiter.api.Assertions.*;

import java.nio.file.*;
import java.util.*;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.io.TempDir;

class GuestRosterTest {
  @TempDir Path dir;

  Path file(String text) throws Exception {
    Path p = dir.resolve("guests.json");
    Files.writeString(p, text);
    return p;
  }

  @Test
  void replacesAndTrims() throws Exception {
    GuestRoster r = new GuestRoster();
    assertTrue(r.load(file("[\" Bonnie \",\"Caroline\"]")));
    assertEquals(List.of("Bonnie", "Caroline"), r.snapshot());
  }

  @Test
  void emptyArrayIsValid() throws Exception {
    GuestRoster r = new GuestRoster();
    assertTrue(r.load(file("[]")));
    assertEquals(List.of(), r.snapshot());
  }

  @Test
  void preservesAfterPartialInvalidData() throws Exception {
    for (String json :
        new String[] {
          "[\"Bonnie\",null]",
          "[\"Bonnie\",7]",
          "[\"Bonnie\",\" \" ]",
          "[\"Bonnie\",\" Bonnie \"]",
          "{broken",
          "{}"
        }) {
      GuestRoster r = new GuestRoster();
      assertFalse(r.load(file(json)), json);
      assertEquals(List.of("Elena"), r.snapshot(), json);
    }
  }

  @Test
  void missingFileKeepsLastSuccessfulLoad() throws Exception {
    GuestRoster r = new GuestRoster();
    assertTrue(r.load(file("[\"Caroline\"]")));
    assertFalse(r.load(dir.resolve("missing.json")));
    assertEquals(List.of("Caroline"), r.snapshot());
  }

  @Test
  void returnedListIsIndependent() throws Exception {
    GuestRoster r = new GuestRoster();
    r.snapshot().clear();
    assertEquals(List.of("Elena"), r.snapshot());
  }

  @Test
  void recoversAcrossSeveralImports() throws Exception {
    GuestRoster roster = new GuestRoster();
    assertTrue(roster.load(file("[\"Bonnie\"]")));
    assertFalse(roster.load(file("[\"Caroline\",null]")));
    assertEquals(List.of("Bonnie"), roster.snapshot());
    assertTrue(roster.load(file("[\"Elena\"]")));
    assertEquals(List.of("Elena"), roster.snapshot());
  }
}
