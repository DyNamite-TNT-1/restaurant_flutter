import 'package:restaurant_flutter/utils/utils.dart';

class TableDetailModel {
  final int tableId;
  final String name;
  final int tableTypeId;
  final bool isDel;
  final int available;

  TableDetailModel({
    this.tableId = 0,
    this.name = "",
    this.tableTypeId = 0,
    this.isDel = false,
    this.available = 0,
  });

  factory TableDetailModel.fromJson(Map<String, dynamic> json) {
    return TableDetailModel(
      tableId: ParseTypeData.ensureInt(json["tableId"]),
      name: ParseTypeData.ensureString(json["name"]),
      tableTypeId: ParseTypeData.ensureInt(json["tableTypeId"]),
      isDel: ParseTypeData.ensureBool(json["isDel"]),
      available: ParseTypeData.ensureInt(json["available"]),
    );
  }

  static List<TableDetailModel> parseListDishItem(dynamic data) {
    List<TableDetailModel> list = [];
    if (data is List) {
      for (var item in data) {
        TableDetailModel model = TableDetailModel.fromJson(item);
        list.add(model);
      }
    }
    return list;
  }
}
