public record SupplyKit(int dressings, int water) {
  public SupplyKit {
    if (dressings < 0 || water < 0) throw new IllegalArgumentException("negative stock");
  }

  public int completeTeams() {
    return Math.min(dressings / 2, water / 3);
  }
}
