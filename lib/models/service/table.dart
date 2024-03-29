// ignore_for_file: unnecessary_overrides

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

  static List<TableDetailModel> parseListItem(dynamic data) {
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

class TableTypeDetailModel {
  final int tableTypeId;
  final String name;
  final String description;
  final double fee;
  TableTypeDetailModel({
    this.tableTypeId = 0,
    this.name = "",
    this.description = "",
    this.fee = 0,
  });

  factory TableTypeDetailModel.fromJson(Map<String, dynamic> json) {
    return TableTypeDetailModel(
      tableTypeId: ParseTypeData.ensureInt(json["tableTypeId"]),
      name: ParseTypeData.ensureString(json["name"]),
      description: ParseTypeData.ensureString(json["description"]),
      fee: ParseTypeData.ensureDouble(json["fee"]),
    );
  }

  static List<TableTypeDetailModel> parseListItem(dynamic data) {
    List<TableTypeDetailModel> list = [];
    if (data is List) {
      for (var item in data) {
        TableTypeDetailModel model = TableTypeDetailModel.fromJson(item);
        list.add(model);
      }
    }
    return list;
  }

  // https://stackoverflow.com/questions/59474307/error-either-zero-or-2-or-more-dropdownmenuitems-were-detected-with-the-same
  @override
  bool operator ==(dynamic other) =>
      other != null &&
      other is TableTypeDetailModel &&
      tableTypeId == other.tableTypeId;

  @override
  int get hashCode => super.hashCode;
}
