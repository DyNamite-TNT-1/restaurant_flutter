import 'package:flutter/material.dart';
import 'package:restaurant_flutter/app_locale_delegate.dart';

import 'asset.dart';

class Translate {
  final Locale locale;
  static const LocalizationsDelegate<Translate> delegate = AppLocaleDelegate();
  late Map<String, String> _localizedStrings;

  Translate(this.locale);

  static Translate of(BuildContext context) {
    return Localizations.of<Translate>(context, Translate)!;
  }

  Future<bool> load() async {
    Map<String, dynamic> jsonMap;
    try {
      jsonMap = await UtilAsset.loadJson(
        "assets/locale/${locale.languageCode}.json",
      );
    } catch (error) {
      jsonMap = await UtilAsset.loadJson(
        "assets/locale/en.json",
      );
    }

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}
