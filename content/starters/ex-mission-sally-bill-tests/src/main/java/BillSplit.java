public class BillSplit {
  public static int[] shares(int cents, int guests) {
    if (cents < 0 || guests < 1 || guests > 12) throw new IllegalArgumentException("invalid bill");
    int[] parts = new int[guests];
    for (int i = 0; i < guests; i++) parts[i] = cents / guests + (i < cents % guests ? 1 : 0);
    return parts;
  }
}
