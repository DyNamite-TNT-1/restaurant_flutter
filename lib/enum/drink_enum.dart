enum DrinkFilter {
  all("Tất cả"),
  wine("Rượu"),
  beer("Bia"),
  soda("Nước ngọt"),
  juice("Nước ép"),
  cockTail("Cocktail"),
  another("Khác");

  final String name;
  const DrinkFilter(this.name);
  static List<DrinkFilter> allDrinkFilter() {
    return DrinkFilter.values;
  }
}
