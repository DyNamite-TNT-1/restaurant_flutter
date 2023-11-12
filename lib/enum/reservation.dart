import 'package:flutter/material.dart';

enum ReservationStatus {
  overSchedule("Không đặt cọc", -3, Color(0XFF8392A5)),
  notPayPreFee("Chưa đặt cọc", -2, Color(0XFFF1C232)),
  rejected("Đã hủy", -1, Color(0XFFBE2020)),
  pending("Xác nhận đặt bàn", 0,Color(0XFF10B759)),
  pendingChanged("Xác nhận đổi bàn", 1, Color(0XFF5B47FB)),
  finishes("Kết thúc", 2, Color(0XFF8B008B));

  final String name;
  final int value;
  final Color color;
  const ReservationStatus(this.name, this.value, this.color);
  static List<ReservationStatus> get all {
    return ReservationStatus.values;
  }

  static ReservationStatus getEnum(int value) {
    return ReservationStatus.all
        .firstWhere((element) => element.value == value);
  }
}
