import 'package:restaurant_flutter/models/client/client_reservation_status.dart';

class Application {
  static const bool supportOTP = true;
  static const bool useHTMLWidgetForAllContent = true;
  static const bool useMarkdownForHTMLLargeContent = true;
  static const bool useMarkdownForHTMLSmallContent = true;
  static const dateFormat = 'yyyy/DD/mm';
  static bool localTimeZone = false;
  static bool debug = false;
  static String versionIntro =
      '1.0.2'; // Change this version if application have new function and would like to introduce
  static bool useShimmerLoading = true;

  // static UserInfo userInfo = UserInfo.empty();

  static List<ClientReservationStatusModel> reservationStatusList = [
    ClientReservationStatusModel(
      type: "Tất cả",
      status: 100,
    ),
    ClientReservationStatusModel(
      type: "Đã kết thúc",
      status: 2,
    ),
    ClientReservationStatusModel(
      type: "Đã duyệt",
      status: 1,
    ),
    ClientReservationStatusModel(
      type: "Xác nhận đặt bàn",
      status: 0,
    ),
    ClientReservationStatusModel(
      type: "Đã hủy",
      status: -1,
    ),
    ClientReservationStatusModel(
      type: "Chưa đặt cọc",
      status: -2,
    ),
    ClientReservationStatusModel(
      type: "Không đặt cọc",
      status: -3,
    ),
  ];

  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
