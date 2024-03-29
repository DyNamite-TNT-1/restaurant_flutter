import 'package:restaurant_flutter/utils/parse_type_value.dart';

class DishDetailModel {
  final int dishId;
  final String name;
  final String description;
  final double price;
  final String priceStr;
  final String image;
  final bool isDel;
  final int dishTypeId;
  final String dishType;
  final String unit;
  int quantity;
  final bool isDrink;

  DishDetailModel({
    this.dishId = 0,
    this.name = "",
    this.description = "",
    this.price = 0,
    this.priceStr = "0",
    this.image = "",
    this.isDel = false,
    this.dishTypeId = 0,
    this.dishType = "",
    this.unit = "",
    this.quantity = 1, //count of this dish in menu, not get from server
    this.isDrink = false,
  });

  factory DishDetailModel.fromJson(Map<String, dynamic> json) {
    return DishDetailModel(
      dishId: ParseTypeData.ensureInt(json["dishId"]),
      name: ParseTypeData.ensureString(json["name"]),
      description: ParseTypeData.ensureString(json["description"]),
      price: ParseTypeData.ensureDouble(json["price"]),
      priceStr: ParseTypeData.ensureString(json["priceStr"]),
      image: ParseTypeData.ensureString(json["image"]),
      isDel: ParseTypeData.ensureBool(json["isDel"]),
      dishTypeId: ParseTypeData.ensureInt(json["dishTypeId"]),
      dishType: ParseTypeData.ensureString(json["dishType"]),
      unit: ParseTypeData.ensureString(json["unit"]),
      isDrink: ParseTypeData.ensureBool(json["isDrink"]),
    );
  }

  static List<DishDetailModel> parseListItem(dynamic data) {
    List<DishDetailModel> list = [];
    if (data is List) {
      for (var item in data) {
        DishDetailModel model = DishDetailModel.fromJson(item);
        list.add(model);
      }
    }
    return list;
  }
}
