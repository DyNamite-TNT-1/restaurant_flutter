import 'package:restaurant_flutter/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? instance;

  static const String token = 'token';
  static const String userModel = 'userModel';

  static Future<void> setPreferences() async {
    instance = await SharedPreferences.getInstance();
  }

  ///Singleton factory
  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();
}

class UserPreferences {
  UserPreferences._();

  static Future<bool> setToken(String token) {
    return UtilPreferences.setString(Preferences.token, token);
  }

  static String? getToken() {
    return UtilPreferences.getString(Preferences.token);
  }

  static Future<bool> setUserLoggedInfo(String userInfo) {
    return UtilPreferences.setString(Preferences.userModel, userInfo);
  }

  static String? getUserLoggedInfo() {
    return UtilPreferences.getString(Preferences.userModel);
  }

  static Future<bool> clearAccountForLogout() {
    UtilPreferences.setString(Preferences.token, '');
    return UtilPreferences.remove(Preferences.userModel);
  }
}
