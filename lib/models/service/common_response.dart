import 'package:restaurant_flutter/utils/utils.dart';

class CommonResponse {
  final bool isSuccess;
  final String msg;
  const CommonResponse({
    this.isSuccess = false,
    this.msg = "",
  });
  
  factory CommonResponse.fromJson(Map<String, dynamic> json) {
    return CommonResponse(
      isSuccess: ParseTypeData.ensureBool(json["isSuccess"]),
      msg: ParseTypeData.ensureString(json["msg"]),
    );
  }
}
