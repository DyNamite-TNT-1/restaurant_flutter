class Images {
  static const String logoApp = "assets/images/logo_website.png";
  static const String logoAppNoBg = "assets/images/logo_website_nobg.png";
  static const String miniLogoApp = "assets/images/mini_logo_website_nobg.png";
  static const String miniLogoAppNoBg =
      "assets/images/mini_logo_website_nobg.png";
  static const String noDataFound = "assets/images/no_data_found.jpg";

  static const String icAvailableCalendar =
      "assets/images/ic_available_calendar.svg";
  static const String icForkKnife = "assets/images/ic_fork_knife.svg";
  static const String icDrink = "assets/images/ic_drink.svg";

  ///Singleton factory
  static final Images _instance = Images._internal();

  factory Images() {
    return _instance;
  }

  Images._internal();
}
