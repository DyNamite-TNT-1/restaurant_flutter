class Images {
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
