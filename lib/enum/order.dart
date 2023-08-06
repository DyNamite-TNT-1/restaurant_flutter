enum OrderEnum {
  desc("Giảm dần", "desc"),
  asc("Tăng dần", "asc");

  final String name;
  final String value;
  const OrderEnum(this.name, this.value);
  static List<OrderEnum> allOrderEnum() {
    return OrderEnum.values;
  }
}
