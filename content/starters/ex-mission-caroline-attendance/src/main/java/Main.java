import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int arrived = input.nextInt(), confirmed = input.nextInt(), seconds = input.nextInt();
    // UPRAVUJ ODSUD
    double percent = arrived / confirmed * 100;
    double minutes = (double) (seconds / 60);
    // UPRAVUJ POTUD
    System.out.println("Ucast: " + percent);
    System.out.println("Minuty: " + minutes);
  }
}
