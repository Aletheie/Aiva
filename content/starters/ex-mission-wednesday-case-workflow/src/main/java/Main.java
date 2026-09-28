import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    State state = State.valueOf(in.next());
    int n = in.nextInt();
    for (int i = 0; i < n; i++) {
      state = Workflow.next(state, in.next());
      System.out.println(state);
    }
    System.out.println("Konec: " + state);
  }
}

enum State {
  OPEN,
  REVIEW,
  CLOSED,
  CANCELLED
}

class Workflow {
  // UPRAVUJ ODSUD
  static State next(State state, String command) {
    return switch (command) {
      case "APPROVE" -> State.CLOSED;
      case "REOPEN" -> State.OPEN;
      default -> State.REVIEW;
    };
  }
  // UPRAVUJ POTUD
}
