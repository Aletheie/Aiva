import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    int distance = in.nextInt(), boxes = in.nextInt();
    Transport[] options = {new FootCourier(), new Van()};
    for (Transport t : options) System.out.println(t.name() + ":" + t.cost(distance, boxes));
  }
}

abstract class Transport {
  abstract String name();

  abstract int cost(int distance, int boxes);
}

// UPRAVUJ ODSUD
class FootCourier extends Transport {
  String name() {
    return "Pesky";
  }

  int cost(int distance, int boxes) {
    return distance * 3;
  }
}

class Van extends Transport {
  String name() {
    return "Dodavka";
  }

  int cost(int distance, int boxes) {
    return (boxes / 10) * (2 * distance + 5);
  }
}
// UPRAVUJ POTUD
