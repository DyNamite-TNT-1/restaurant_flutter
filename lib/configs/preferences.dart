import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:restaurant_flutter/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? instance;

  static const String language = 'language';  
  static const String token = 'token';
  static const String userModel = 'userModel';
  static const String userLogin = "userLogin";
  static const String securePasword = 'secretAppKey';

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

    static Future<bool> setLanguage(String langName) {
    return UtilPreferences.setString(Preferences.language, langName);
  }

  static String? getLanguage() {
    return UtilPreferences.getString(Preferences.language);
  }

  static Future<bool> setSecurePassword(String password) async {
    // String enPass = encryptPassword(password);
    return UtilPreferences.setString(Preferences.securePasword, password);
  }

  static Future<String> getSecurePassword() async {
    String? enPass = UtilPreferences.getString(Preferences.securePasword);
    if (enPass == null || enPass.isEmpty) {
      return "";
    }
    return enPass;
  }

  static Future<bool> setToken(String token) {
    return UtilPreferences.setString(Preferences.token, token);
  }

  static String? getToken() {
    return UtilPreferences.getString(Preferences.token);
  }

  static bool isExistAuthenticateSession() {
    String? token = getToken();
    if (token != null && token != "") {
      return true;
    }
    return false;
  }

  static Future<bool> setUserLogin(String userLogin) {
    return UtilPreferences.setString(Preferences.userLogin, userLogin);
  }

  static String? getUserLogin() {
    return UtilPreferences.getString(Preferences.userLogin);
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

String encryptPassword(String password) {
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  return hash.toString();
}
