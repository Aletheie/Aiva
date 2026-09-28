import static org.junit.jupiter.api.Assertions.*;

import java.nio.file.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;

class PantryReportTest {
  @TempDir Path dir;

  Path data(String text) throws Exception {
    Path file = dir.resolve("data.csv");
    Files.writeString(file, text);
    return file;
  }

  @Test
  void listsOnlyShortages() throws Exception {
    assertEquals("Rice: doplnit 3", PantryReport.report(data("Rice,2,5\nTea,4,4\n")));
  }

  @Test
  void noShortage() throws Exception {
    assertEquals("Vseho je dost", PantryReport.report(data("# pantry\n\nTea,5,4\n")));
  }

  @Test
  void invalidData() throws Exception {
    assertThrows(IllegalArgumentException.class, () -> PantryReport.report(data("Rice,-1,5\n")));
  }
}
