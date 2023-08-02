enum DishFilter {
  all("Tất cả"),
  appetizer("Khai vị"),
  mainDish("Món chính"),
  soup("Soup"),
  dessert("Tráng miệng");

  final String name;
  const DishFilter(this.name);
  static List<DishFilter> allDishFilter() {
    return DishFilter.values;
  }
}
