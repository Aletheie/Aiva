import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int a = input.nextInt(), b = input.nextInt(), moved = input.nextInt(), perBox = input.nextInt();
    // UPRAVUJ ODSUD
    a = moved;
    b = b + a;
    int pieces = a + b * perBox;
    System.out.println("A: " + a);
    System.out.println("B: " + b);
    System.out.println("Kusy: " + pieces);
    // UPRAVUJ POTUD

  }
}
