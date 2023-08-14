import 'package:restaurant_flutter/utils/utils.dart';

class ResultModel {
  final bool isSuccess;
  final String message;
  final dynamic data;
  dynamic attrs;
  dynamic parent;
  final bool isCancelled;

  ResultModel({
    required this.isSuccess,
    required this.message,
    this.isCancelled = false,
    this.data,
    this.attrs,
    this.parent,
  });

  factory ResultModel.cancelItem() {
    return ResultModel(
      isSuccess: false,
      message: "",
      isCancelled: true,
    );
  }

  factory ResultModel.empty() {
    return ResultModel(
      isSuccess: false,
      message: "",
    );
  }

  factory ResultModel.fromJson(dynamic jsonObj) {
    if (jsonObj == null) {
      return ResultModel.cancelItem();
    }
    if (jsonObj is! Map<String, dynamic>) {
      return ResultModel.empty();
    }
    Map<String, dynamic> json = jsonObj;
    return ResultModel(
      isSuccess: ParseTypeData.ensureBool(json['isSuccess']),
      message: ParseTypeData.ensureString(
          (json['message'] ?? json['msg']) ?? 'Error'),
      data: json.containsKey('rows') ? json['rows'] : json['data'],
      attrs: json.containsKey('attrs') ? json['attrs'] : json['attr'],
      parent: json['parent'],
    );
  }
}
