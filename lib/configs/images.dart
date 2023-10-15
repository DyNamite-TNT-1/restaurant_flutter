class AssetImages {
  static const String logoApp = "assets/images/logo_website.png";
  static const String logoAppNoBg = "assets/images/logo_website_nobg.png";
  static const String miniLogoApp = "assets/images/mini_logo_website_nobg.png";
  static const String miniLogoAppNoBg =
      "assets/images/mini_logo_website_nobg.png";
  static const String logoAppDarkMode =
      "assets/images/logo_website_darkmode.png";
  static const String logoAppDarkModeNoBg =
      "assets/images/logo_website_darkmode_nobg.png";
  static const String backgroundLogin = "assets/images/background_login.jpg";
  //slider on dashboard
  static const String slider1 = "assets/images/slider1.png";
  static const String slider2 = "assets/images/slider2.png";

  static const String noDataFound = "assets/images/no_data_found.jpg";

  static const String icAvailableCalendar =
      "assets/images/ic_available_calendar.svg";
  static const String icForkKnife = "assets/images/ic_fork_knife.svg";
  static const String icDrink = "assets/images/ic_drink.svg";
  static const String icMicro = "assets/images/ic_micro.svg";

  static const String icSearch = "assets/images/ic_search.svg";
  static const String icChecked = "assets/images/ic_checked.svg";
  static const String icClear = "assets/images/ic_clear.svg";
  static const String noAvatarUser = "assets/images/no_avatar_user.svg";

  ///Singleton factory
  static final AssetImages _instance = AssetImages._internal();

  factory AssetImages() {
    return _instance;
  }

  AssetImages._internal();
}
