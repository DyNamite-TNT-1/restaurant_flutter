class ClientReservationStatusModel {
  final String type;
  final int status;
  ClientReservationStatusModel({
    this.type = "",
    this.status = 100, //default: 100 is "get All"
  });
}
