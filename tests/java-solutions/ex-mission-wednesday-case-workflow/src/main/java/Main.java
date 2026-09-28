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
    return switch (state) {
      case OPEN ->
          switch (command) {
            case "SUBMIT" -> State.REVIEW;
            case "CANCEL" -> State.CANCELLED;
            default -> state;
          };
      case REVIEW ->
          switch (command) {
            case "APPROVE" -> State.CLOSED;
            case "RETURN" -> State.OPEN;
            case "CANCEL" -> State.CANCELLED;
            default -> state;
          };
      case CLOSED -> command.equals("REOPEN") ? State.OPEN : state;
      case CANCELLED -> state;
    };
  }
  // UPRAVUJ POTUD
}
