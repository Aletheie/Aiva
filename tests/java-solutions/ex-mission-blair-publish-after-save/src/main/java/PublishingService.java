import java.io.IOException;

interface ArticleRepository {
  int save(String title) throws IOException;
}

interface Announcement {
  void send(int id, String title);
}

public class PublishingService {
  private final ArticleRepository repo;
  private final Announcement announcement;

  public PublishingService(ArticleRepository repo, Announcement announcement) {
    this.repo = repo;
    this.announcement = announcement;
  }

  // UPRAVUJ ODSUD
  public int publish(String title) throws IOException {
    String normalized = title.trim();
    if (normalized.isEmpty()) throw new IllegalArgumentException("empty title");
    int id = repo.save(normalized);
    announcement.send(id, normalized);
    return id;
  }
  // UPRAVUJ POTUD
}
