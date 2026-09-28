import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner input = new Scanner(System.in);
    int people = input.nextInt(),
        meal = input.nextInt(),
        drink = input.nextInt(),
        coupon = input.nextInt();
    System.out.println(priceForGroup(people, meal, drink, coupon));
  }

  static int priceForGroup(int people, int meal, int drink, int coupon) {
    // UPRAVUJ ODSUD
    return people * meal + drink - coupon;
    // UPRAVUJ POTUD
  }

  static int discountPercent(int people) {
    return people >= 8 ? 10 : people >= 4 ? 5 : 0;
  }
}
