import 'package:restaurant_flutter/utils/parse_type_value.dart';

class ReservationDetailModel {
  final int reservationId;
  final int preFee;
  final String deadline;
  ReservationDetailModel({
    this.reservationId = 0,
    this.preFee = 0,
    this.deadline = "",
  });

  factory ReservationDetailModel.fromJson(Map<String, dynamic> json) {
    return ReservationDetailModel(
      reservationId: ParseTypeData.ensureInt(json["reservationId"]),
      preFee: ParseTypeData.ensureInt(json["preFee"]),
      deadline: ParseTypeData.ensureString(json["deadline"]),
    );
  }
}
