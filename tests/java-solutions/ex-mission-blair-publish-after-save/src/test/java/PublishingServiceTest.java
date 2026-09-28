import static org.junit.jupiter.api.Assertions.*;

import java.io.IOException;
import java.util.*;
import org.junit.jupiter.api.Test;

class PublishingServiceTest {
  @Test
  void announcesOnlyAfterSave() throws Exception {
    List<String> events = new ArrayList<>();
    ArticleRepository repo =
        title -> {
          events.add("save:" + title);
          return 17;
        };
    Announcement notice = (id, title) -> events.add("send:" + id + ":" + title);
    assertEquals(17, new PublishingService(repo, notice).publish(" Opening night "));
    assertEquals(List.of("save:Opening night", "send:17:Opening night"), events);
  }

  @Test
  void saveFailureDoesNotAnnounce() {
    List<String> events = new ArrayList<>();
    IOException failure = new IOException("offline");
    ArticleRepository repo =
        title -> {
          events.add("save");
          throw failure;
        };
    Announcement notice = (id, title) -> events.add("send");
    assertSame(
        failure,
        assertThrows(IOException.class, () -> new PublishingService(repo, notice).publish("News")));
    assertEquals(List.of("save"), events);
  }

  @Test
  void blankTitleHasNoSideEffects() {
    List<String> events = new ArrayList<>();
    ArticleRepository repo =
        title -> {
          events.add("save");
          return 17;
        };
    Announcement notice = (id, title) -> events.add("send");
    assertThrows(
        IllegalArgumentException.class, () -> new PublishingService(repo, notice).publish("  "));
    assertTrue(events.isEmpty());
  }
}
