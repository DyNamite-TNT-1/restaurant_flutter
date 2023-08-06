import 'package:restaurant_flutter/utils/utils.dart';

class DishTypeModel {
  final int dishTypeId;
  final String type;
  final bool isDrinkType;
  DishTypeModel({
    this.dishTypeId = 0,
    this.type = "",
    this.isDrinkType = false,
  });

  factory DishTypeModel.fromJson(Map<String, dynamic> json) {
    return DishTypeModel(
      dishTypeId: ParseTypeData.ensureInt(json["dishTypeId"]),
      type: ParseTypeData.ensureString(json["type"]),
      isDrinkType: ParseTypeData.ensureBool(json["isDrinkType"]),
    );
  }

  static List<DishTypeModel> parseListDishTypeItem(dynamic data) {
    List<DishTypeModel> list = [];
    if (data is List) {
      for (var item in data) {
        DishTypeModel model = DishTypeModel.fromJson(item);
        list.add(model);
      }
    }
    return list;
  }
}

class DishTypeFilterModel {
  final bool isSuccess;
  final List<DishTypeModel> dishTypes;
  DishTypeFilterModel({
    this.isSuccess = false,
    this.dishTypes = const [],
  });

  factory DishTypeFilterModel.fromJson(Map<String, dynamic> json) {
    return DishTypeFilterModel(
      isSuccess: ParseTypeData.ensureBool(json["isSuccess"]),
      dishTypes: DishTypeModel.parseListDishTypeItem(json["dishTypes"]),
    );
  }
}
