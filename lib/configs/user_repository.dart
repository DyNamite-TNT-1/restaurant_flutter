import 'dart:convert';

import 'package:restaurant_flutter/api/api.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/models/service/common_response.dart';
import 'package:restaurant_flutter/models/service/user.dart';
import 'package:restaurant_flutter/utils/utils.dart';

class UserRepository {
  static UserModel? _userModel;
  static UserModel get userModel {
    if (_userModel == null) {
      String? userString = UserPreferences.getUserLoggedInfo();
      if (userString != null) {
        Map<String, dynamic> json = jsonDecode(userString);
        _userModel = UserModel.fromJson(json);
      }
    }
    return _userModel ?? UserModel.empty();
  }

  static void setUserModel(Map<String, dynamic>? json) {
    _userModel = json == null ? null : UserModel.fromJson(json);
    print("_userModel?.userName: ${_userModel?.userName}");
  }

  // static bool isMe({required String u_cn, required String u_no}) {
  //   return userModel.u_cn == u_cn && userModel.u_no == u_no;
  // }

  ///Login
  static Future<UserModel?> login({
    required String domain,
    required String username,
    required String password,
    required String pushtoken,
    required String otpCode,
  }) async {
    try {
      final result = await Api.requestLogin(
          // domain: domain,
          // id: username,
          // pass: password,
          // token: pushtoken,
          // otpcode: otpCode,
          );

      ///Case API success
      // if (result.success) {
      //   _userModel = result;

      //   await UserPreferences.setSecurePassword(password);
      //   await UserPreferences.setUserLoggedInfo(
      //       json.encode(result.toDatabase()));
      //   await UserPreferences.setDomain(domain);
      //   await UserPreferences.setUserId(username);
      //   await UserPreferences.setHanGWSession(result.cookie);
      //   await UserPreferences.setHmailKey(result.hmail_key);
      // }
      return result;
    } catch (e) {
      UtilLogger.log('Exception Login', e);
    }
    return null;
  }

  static Future<CommonResponse?> logout(bool ignoreApi, int timeout) async {
    if (!ignoreApi) {
      // Api.requestLogout();
    }

    // cheat for wating logout after timeout seconds
    await Future.delayed(Duration(seconds: timeout));

    ///Case API success
    UserRepository.setUserModel(null);
    await UserPreferences.clearAccountForLogout();

    return null;
  }

  ///Singleton factory
  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal();
}
