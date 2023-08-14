import 'package:restaurant_flutter/utils/utils.dart';

class UserModel {
  final int userId;
  final String userName;
  final String address;
  final bool gender;
  final String role;
  final int roleId;
  final bool isSuccess;
  final String accessToken;
  final int expireTime;
  final String msg;

  UserModel({
    this.userId = 0,
    this.userName = "",
    this.address = "",
    this.role = "",
    this.gender = false,
    this.roleId = 0,
    this.isSuccess = false,
    this.accessToken = "",
    this.expireTime = 0,
    this.msg = "",
  });

  factory UserModel.empty() {
    return UserModel(
      userId: 0,
      userName: "",
      address: "",
      isSuccess: false,
      gender: false,
      role: "",
      roleId: 0,
      accessToken: "",
      expireTime: 0,
      msg: "",
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: ParseTypeData.ensureInt(json["userId"]),
      userName: ParseTypeData.ensureString(json["userName"]),
      address: ParseTypeData.ensureString(json["address"]),
      gender: ParseTypeData.ensureBool(json["gender"]),
      role: ParseTypeData.ensureString(json["role"]),
      roleId: ParseTypeData.ensureInt(json["roleId"]),
      isSuccess: ParseTypeData.ensureBoolDef(json["isSuccess"], false),
      accessToken: ParseTypeData.ensureString(json["accessToken"]),
      expireTime: ParseTypeData.ensureInt(json["expireTime"]),
      msg: ParseTypeData.ensureString(json["msg"]),
    );
  }

  bool get isManager {
    return roleId == 2 ? true : false;
  }

  bool get isAdmin {
    return roleId == 1 ? true : false;
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userName": userName,
      "address": address,
      "gender": gender,
      "role": role,
      "roleId": roleId,
      "isSuccess": isSuccess,
      "accessToken": accessToken,
      "expireTime": expireTime,
    };
  }
}
