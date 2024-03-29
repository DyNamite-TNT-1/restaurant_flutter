import 'package:restaurant_flutter/configs/configs.dart';

class UtilLanguage {
  ///Get Language Global Language Name
  static String getGlobalLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Vietnamese';
      case 'ar':
        return 'Arabic';
      case 'da':
        return 'Danish';
      case 'de':
        return 'German';
      case 'el':
        return 'Greek';
      case 'fr':
        return 'French';
      case 'he':
        return 'Hebrew';
      case 'id':
        return 'Indonesian';
      case 'ja':
        return 'Japanese';
      case 'ko':
        return 'Korean';
      case 'lo':
        return 'Lao';
      case 'nl':
        return 'Dutch';
      case 'zh':
        return 'Chinese';
      case 'fa':
        return 'Iran';
      case 'km':
        return 'Cambodian';
      case 'ru':
        return 'Russian';
      default:
        return 'Unknown';
    }
  }

  static bool isRTL() {
    switch (UserPreferences.getLanguage()) {
      case "ar":
      case "he":
        return true;
      default:
        return false;
    }
  }

  ///Singleton factory
  static final _instance = UtilLanguage._internal();

  factory UtilLanguage() {
    return _instance;
  }

  UtilLanguage._internal();
}
