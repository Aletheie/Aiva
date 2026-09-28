import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;

class NewsletterTest {
  @Test
  void trimsHeadline() {
    assertEquals("{\"title\":\"Opening night\"}", Newsletter.preview(" Opening night "));
  }

  @Test
  void preservesEmptyTitle() {
    assertEquals("{\"title\":\"\"}", Newsletter.preview(" "));
  }

  @Test
  void escapesQuotes() {
    assertEquals(
        "{\"title\":\"Blair says \\\"hello\\\"\"}", Newsletter.preview("Blair says \"hello\""));
  }
}
