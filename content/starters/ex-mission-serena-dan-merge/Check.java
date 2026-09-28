public class Check {
  public static void main(String[] args) {
    expect("Upper East Side | Opening night", Newsletter.subject(" Opening night "));
    expect("Upper East Side | (bez titulku)", Newsletter.subject("   "));
    expect("Upper East Side | (bez titulku)", Newsletter.subject(""));
    System.out.println("3 kontroly prosly");
  }

  private static void expect(String expected, String actual) {
    if (!expected.equals(actual))
      throw new AssertionError("Expected: " + expected + "; actual: " + actual);
  }
}
