import 'package:flutter/material.dart';

enum DarkOption { dynamic, alwaysOn, alwaysOff }

class AppTheme {
  ///Optional Color
  static Color blueColor = Color.fromRGBO(93, 173, 226, 1);
  static Color pinkColor = Color.fromRGBO(165, 105, 189, 1);
  static Color greenColor = Color.fromRGBO(88, 214, 141, 1);
  static Color yellowColor = Color.fromRGBO(253, 198, 10, 1);

  ///Default font

  static String currentFont = 'OpenSans';

  ///List Font support
  static List<String> fontSupport = [
    "OpenSans",
    "Raleway",
    "Roboto",
    "Merriweather",
  ];

  // ///Default Theme
  // static ThemeModel currentTheme = ThemeModel.fromJson({
  //   "name": "default",
  //   "color": "1A7BFF",
  //   "light": "defaultLight",
  //   "dark": "defaultDark",
  // });

  // ///List Theme Support in Application
  // static List<ThemeModel> themeSupport = [
  //   {
  //     "name": "default",
  //     "primary": "1A7BFF",
  //     "light": "defaultLight",
  //     "dark": "defaultDark",
  //   },
  //   {
  //     "name": "orange",
  //     "primary": "f4a261",
  //     "light": "orangeLight",
  //     "dark": "orangeDark",
  //   },
  //   {
  //     "name": "purple",
  //     "primary": "625597",
  //     "light": "purpleLight",
  //     "dark": "purpleDark",
  //   }
  // ].map((item) => ThemeModel.fromJson(item)).toList();

  ///Dark Theme option
  // static DarkOption darkThemeOption = DarkOption.alwaysOff;

  // static ThemeData lightTheme = CollectionTheme.getCollectionTheme(
  //   theme: currentTheme.name,
  //   font: currentFont,
  // );

  // static ThemeData darkTheme = CollectionTheme.getCollectionTheme(
  //     theme: currentTheme.name, font: currentFont);

  ///Singleton factory
  static final AppTheme _instance = AppTheme._internal();

  factory AppTheme() {
    return _instance;
  }

  AppTheme._internal();
}
