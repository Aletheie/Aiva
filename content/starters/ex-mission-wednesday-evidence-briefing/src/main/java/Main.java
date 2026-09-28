import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    board = new Board(input);
    printBriefing();
  }

  static void printBriefing() {
    // UPRAVUJ ODSUD
    System.out.println("POTVRZENE");
    for (int i = 0; i < board.size(); i++) System.out.println(board.labelAt(i));
    System.out.println("Pocet: " + board.size());
    // UPRAVUJ POTUD
  }

  static Board board;

  static class Board {
    private final String[] labels;
    private final boolean[] confirmed;

    Board(Scanner input) {
      int n = Integer.parseInt(input.nextLine());
      labels = new String[n];
      confirmed = new boolean[n];
      for (int i = 0; i < n; i++) {
        labels[i] = input.nextLine();
        confirmed[i] = Boolean.parseBoolean(input.nextLine());
      }
    }

    int size() {
      return labels.length;
    }

    String labelAt(int i) {
      return labels[i];
    }

    boolean isConfirmedAt(int i) {
      return confirmed[i];
    }
  }
}
