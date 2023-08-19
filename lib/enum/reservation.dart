enum ReservationStatus {
  notPayPreFee("Chưa đặt cọc", -2),
  rejected("Từ chối", -1),
  pending("Xác nhận đặt bàn", 0),
  approved("Đã duyệt", 1),
  finishes("Kết thúc", 2);

  final String name;
  final int value;
  const ReservationStatus(this.name, this.value);
  static  List<ReservationStatus> get all {
    return ReservationStatus.values;
  }
}
