import 'package:restaurant_flutter/models/service/dish.dart';
import 'package:restaurant_flutter/utils/parse_type_value.dart';

class ClientDishModel {
  final int total;
  final int maxPage;
  final int currentPage;
  final List<DishDetailModel> dishes;
  ClientDishModel({
    this.total = 0,
    this.maxPage = 0,
    this.currentPage = 0,
    this.dishes = const [],
  });
  factory ClientDishModel.fromJson(Map<String, dynamic> json) {
    return ClientDishModel(
      total: ParseTypeData.ensureInt(json["total"]),
      maxPage: ParseTypeData.ensureInt(json["maxPage"]),
      currentPage: ParseTypeData.ensureInt(json["currentPage"]),
      dishes: DishDetailModel.parseListItem(json["rows"]),
    );
  }
}
