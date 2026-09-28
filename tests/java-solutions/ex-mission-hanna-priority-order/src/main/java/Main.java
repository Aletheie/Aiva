import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    String[] places = {input.nextLine(), input.nextLine(), input.nextLine()};
    // UPRAVUJ ODSUD
    String urgent = places[2];
    places[2] = places[1];
    places[1] = places[0];
    places[0] = urgent;
    // UPRAVUJ POTUD
    for (String place : places) System.out.println(place);
  }
}
