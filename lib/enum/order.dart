enum OrderEnum {
  desc("desc", "desc"),
  asc("asc", "asc");

  final String name;
  final String value;
  const OrderEnum(this.name, this.value);
  static List<OrderEnum> allOrderEnum() {
    return OrderEnum.values;
  }
}
