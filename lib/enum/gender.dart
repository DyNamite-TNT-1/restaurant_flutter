enum GenderEnum {
  male("male", 0),
  female("female", 1);

  final String name;
  final int value;
  const GenderEnum(this.name, this.value);
  static List<GenderEnum> allGenderEnum() {
    return GenderEnum.values;
  }
}
