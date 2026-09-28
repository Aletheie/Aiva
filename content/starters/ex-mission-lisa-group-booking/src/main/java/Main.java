import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int capacity = input.nextInt(), reserved = input.nextInt(), requested = input.nextInt();
    // UPRAVUJ ODSUD
    reserved += requested;
    if (requested < capacity - reserved) System.out.println("POTVRZENA");
    else System.out.println("CEKACI");
    // UPRAVUJ POTUD
    System.out.println("Volno: " + (capacity - reserved));
  }
}
