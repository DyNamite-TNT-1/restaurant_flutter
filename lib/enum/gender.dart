enum GenderEnum {
  male("Nam", 0),
  female("Nữ", 1);

  final String name;
  final int value;
  const GenderEnum(this.name, this.value);
  static List<GenderEnum> allGenderEnum() {
    return GenderEnum.values;
  }
}
