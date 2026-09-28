import java.util.*;

public class Main {
  public static void main(String[] args) throws Exception {
    Scanner in = new Scanner(System.in);
    String name = in.nextLine();
    int price = in.nextInt(), discount = in.nextInt();
    Pass regular = new Pass(name, price);
    Pass reduced = new DiscountPass(name, price, discount);
    System.out.println(regular.label() + ":" + regular.price());
    System.out.println(reduced.label() + ":" + reduced.price());
  }
}

class Pass {
  private final String name;
  private final int fee;

  Pass(String name, int fee) {
    this.name = name;
    this.fee = fee;
  }

  String label() {
    return name;
  }

  int price() {
    return fee;
  }
}

class DiscountPass extends Pass {
  // UPRAVUJ ODSUD
  private final int discount;

  DiscountPass(String name, int fee, int discount) {
    super(name, fee);
    this.discount = discount;
  }

  @Override
  String label() {
    return super.label() + "/zvyhodnena";
  }

  @Override
  int price() {
    return Math.max(0, super.price() - discount);
  }
  // UPRAVUJ POTUD
}
