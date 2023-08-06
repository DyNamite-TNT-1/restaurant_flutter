import 'package:flutter/material.dart';

import 'configs.dart';

// const _defaultLightPrimary = Color(0xff3479F6);
// const _orangeLightPrimary = Color(0xfff4a261);
// const _purpleLightPrimary = Color(0xff625597);
// const _otherPrimary = Color(0xff3479F6);

class CollectionTheme {
  ///Get collection theme

  static ThemeData getCollectionTheme(
      // {
      // String theme = "defaultLight",
      // required String font,
      // }
      ) {
    // final whiteColor = Color(0xfff9fbfd);

    // Color appBarColor;
    // ColorScheme colorScheme;
    // switch (theme) {
    //   case "defaultLight":
    //     colorScheme = ColorScheme.light(
    //       primary: _defaultLightPrimary,
    //       secondary: Color(0xff00c7d8),
    //       surface: const Color(0xfff4f6f8),
    //       surfaceVariant: const Color(0xffC0CCDA),
    //       background: whiteColor,
    //       error: Colors.red,
    //       onPrimary: whiteColor,
    //       onSecondary: Colors.black,
    //       onSurface: Colors.black,
    //       onBackground: Colors.black,
    //       onError: whiteColor,
    //       brightness: Brightness.light,
    //     );
    //     appBarColor = Colors.white;
    //     break;
    //   case "defaultDark":
    //     colorScheme = ColorScheme.dark(
    //       primary: _defaultLightPrimary,
    //       secondary: Color(0xff00c7d8),
    //       surface: const Color(0xfff4f6f8),
    //       surfaceVariant: const Color(0xffC0CCDA),
    //       background: Color(0xff203247),
    //       error: Colors.red,
    //       onPrimary: Colors.black,
    //       onSecondary: Colors.black,
    //       onSurface: whiteColor,
    //       onBackground: whiteColor,
    //       onError: Colors.black,
    //       brightness: Brightness.dark,
    //     );
    //     appBarColor = Color(0xff838383);
    //     break;

    //   case "orangeLight":
    //     colorScheme = ColorScheme.light(
    //       primary: _orangeLightPrimary,
    //       secondary: Color(0xff2A9D8F),
    //       surface: const Color(0xfff4f6f8),
    //       surfaceVariant: const Color(0xffC0CCDA),
    //       background: Colors.white,
    //       error: Colors.red,
    //       onPrimary: Colors.white,
    //       onSecondary: Colors.black,
    //       onSurface: Colors.black,
    //       onBackground: Colors.black,
    //       onError: Colors.white,
    //       brightness: Brightness.light,
    //     );
    //     appBarColor = Colors.white;
    //     break;
    //   case "orangeDark":
    //     colorScheme = ColorScheme.dark(
    //       primary: _orangeLightPrimary,
    //       secondary: Color(0xff2A9D8F),
    //       surface: const Color(0xfff4f6f8),
    //       surfaceVariant: const Color(0xffC0CCDA),
    //       background: Color(0xff121212),
    //       error: Colors.red,
    //       onPrimary: Colors.black,
    //       onSecondary: Colors.black,
    //       onSurface: Colors.white,
    //       onBackground: Colors.white,
    //       onError: Colors.black,
    //       brightness: Brightness.dark,
    //     );
    //     appBarColor = Color(0xff838383);
    //     break;

    //   case "purpleLight":
    //     colorScheme = ColorScheme.light(
    //       primary: _purpleLightPrimary,
    //       secondary: Color(0xff264653),
    //       surface: const Color(0xfff4f6f8),
    //       surfaceVariant: const Color(0xffC0CCDA),
    //       background: Colors.white,
    //       error: Colors.red,
    //     );

    //     appBarColor = Colors.white;
    //     break;
    //   case "purpleDark":
    //     colorScheme = ColorScheme.light(
    //       primary: _purpleLightPrimary,
    //       secondary: Color(0xff264653),
    //       surface: const Color(0xfff4f6f8),
    //       surfaceVariant: const Color(0xffC0CCDA),
    //       background: Colors.white,
    //       error: Colors.red,
    //     );
    //     appBarColor = Color(0xff838383);
    //     break;

    //   default:
    //     colorScheme = ColorScheme.light(
    //       primary: _otherPrimary,
    //       secondary: Color(0xff00c7d8),
    //       surface: whiteColor,
    //       surfaceVariant: const Color(0xffC0CCDA),
    //       background: whiteColor,
    //       error: Colors.red,
    //       onPrimary: whiteColor,
    //       onSecondary: Colors.black,
    //       onSurface: Colors.black,
    //       onBackground: Colors.black,
    //       onError: whiteColor,
    //       brightness: Brightness.light,
    //     );
    //     appBarColor = Colors.white;
    //     break;
    // }

    // final dark = colorScheme.brightness == Brightness.dark;
    // final primaryColor = dark ? colorScheme.surface : colorScheme.primary;

    // final indicatorColor = dark ? colorScheme.onSurface : colorScheme.onPrimary;
    const primaryTextColor = textColor;
    const headerTextColor = textColor;
    const secondaryTextColor = subTextColor;
    const bodyMediumColor = textColor;
    return ThemeData(
      primaryColor: primaryColor,
      // brightness: colorScheme.brightness,
      // primaryColor: colorScheme.primary,
      appBarTheme:
          AppBarTheme(color: Colors.white, foregroundColor: primaryTextColor),
      // canvasColor: colorScheme.background,
      // scaffoldBackgroundColor: colorScheme.background,
      scaffoldBackgroundColor: backgroundColor,
      // cardColor: colorScheme.surface,
      // dividerColor: colorScheme.onSurface.withOpacity(0.12),
      // dialogBackgroundColor: colorScheme.background,
      // indicatorColor: indicatorColor,
      // applyElevationOverlayColor: dark,
      // colorScheme: colorScheme,
      // fontFamily:
      //     font, // how to get system font follow system setting cannot get
      buttonTheme: ButtonThemeData(
        padding: EdgeInsets.all(0),
        textTheme: ButtonTextTheme.primary,
        minWidth: 100,
        height: 36,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        // colorScheme: colorScheme,
        // buttonColor: colorScheme.primary,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            // header
            fontFamily: AppTheme.currentFont,
            color: headerTextColor,
            fontSize: kfontSizeHeadlineLarge,
            fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            // header
            fontFamily: AppTheme.currentFont,
            color: headerTextColor,
            fontSize: kfontSizeHeadlineMedium,
            fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(
            // subheader
            fontFamily: AppTheme.currentFont,
            color: headerTextColor,
            fontSize: kfontSizeHeadlineSmall,
            fontWeight: FontWeight.bold),
        titleLarge: TextStyle(
            fontFamily: AppTheme.currentFont,
            color: primaryTextColor,
            fontSize: kfontSizeTitleSemiLarge,
            fontWeight: FontWeight.w600),
        titleMedium: TextStyle(
            fontFamily: AppTheme.currentFont,
            color: primaryTextColor,
            fontSize: kfontSizeTitleMedium,
            fontWeight: FontWeight.w600),
        titleSmall: TextStyle(
            fontFamily: AppTheme.currentFont,
            color: secondaryTextColor,
            fontSize: kfontSizeTitleMedium,
            fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(
            fontFamily: AppTheme.currentFont,
            color: primaryTextColor,
            fontSize: kfontSizeBodyLarge,
            fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(
            fontFamily: AppTheme.currentFont,
            color: bodyMediumColor,
            fontSize: kfontSizeBodyMedium,
            fontWeight: FontWeight.w400),
        bodySmall: TextStyle(
            fontFamily: AppTheme.currentFont,
            color: secondaryTextColor,
            fontSize: kfontSizebodySmall,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  ///Singleton factory
  static final CollectionTheme _instance = CollectionTheme._internal();

  factory CollectionTheme() {
    return _instance;
  }

  CollectionTheme._internal();
}

// extension CustomColorScheme on ColorScheme {
//   Color get highLightColor {
//     if (this.primary == _defaultLightPrimary) {
//       return Color(0xFFf60000);
//     }
//     if (this.primary == _orangeLightPrimary) {
//       return Color(0xFFf60000);
//     }
//     if (this.primary == _purpleLightPrimary) {
//       return Color(0xFFf60000);
//     }
//     if (this.primary == _otherPrimary) {
//       return Color(0xFFf60000);
//     }
//     return Color(0xFFf60000);
//   }

//   Color get otherGrayColor {
//     if (this.primary == _defaultLightPrimary) {
//       return Color(0xFFF4F6F8);
//     }
//     if (this.primary == _orangeLightPrimary) {
//       return Color(0xFFF4F6F8);
//     }
//     if (this.primary == _purpleLightPrimary) {
//       return Color(0xFFF4F6F8);
//     }
//     if (this.primary == _otherPrimary) {
//       return Color(0xFFF4F6F8);
//     }
//     return Color(0xFFF4F6F8);
//   }

//   Color get otherTextColor {
//     if (this.primary == _defaultLightPrimary) {
//       return Color(0xff8392A5);
//     }
//     if (this.primary == _orangeLightPrimary) {
//       return Color(0xff8392A5);
//     }
//     if (this.primary == _purpleLightPrimary) {
//       return Color(0xff8392A5);
//     }
//     if (this.primary == _otherPrimary) {
//       return Color(0xff8392A5);
//     }
//     return Color(0xff8392A5);
//   }
// }
