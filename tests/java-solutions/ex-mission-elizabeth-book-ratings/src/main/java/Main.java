import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int sumA = input.nextInt(),
        countA = input.nextInt(),
        sumB = input.nextInt(),
        countB = input.nextInt();
    // UPRAVUJ ODSUD
    int votes = countA + countB;
    double average = (double) (sumA + sumB) / votes;
    System.out.println("Hlasy: " + votes);
    System.out.println("Prumer: " + average);
    // UPRAVUJ POTUD

  }
}
