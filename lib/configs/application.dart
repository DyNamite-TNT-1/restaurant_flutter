import 'package:restaurant_flutter/api/api.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Application {
  static const bool supportOTP = true;
  static const bool useHTMLWidgetForAllContent = true;
  static const bool useMarkdownForHTMLLargeContent = true;
  static const bool useMarkdownForHTMLSmallContent = true;
  static const dateFormat = 'yyyy/DD/mm';
  static bool localTimeZone = false;
  static bool debug = true;
  static String versionIntro =
      '1.0.2'; // Change this version if application have new function and would like to introduce
  static bool useShimmerLoading = true;

  // static List<CommonSettingModel> commonSettings = [];

  // static UserInfo userInfo = UserInfo.empty();

  // static SettingInitModel settingInit = SettingInitModel.empty();

  static Map<String, dynamic> recent_activity_setting = {};

  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}

class SocketClient {
  static IO.Socket? socket;

  static void connectSocket() {
    socket = IO.io(
      Api.branchGetter(),
      IO.OptionBuilder().setTransports(['websocket']).setQuery(
          {'username': "ANHDUC"}).build(),
    );
  }

  ///Singleton factory
  static final SocketClient _instance = SocketClient._internal();

  factory SocketClient() {
    return _instance;
  }

  SocketClient._internal();
}
