import 'package:restaurant_flutter/utils/utils.dart';

class ServiceDetailModel {
  final int serviceId;
  final String name;
  final double price;
  final String priceStr;
  final String image;
  final String unit;
  int quantity;
  ServiceDetailModel({
    this.serviceId = 0,
    this.name = "",
    this.price = 0,
    this.priceStr = "0",
    this.image = "",
    this.unit = "",
    this.quantity = 1, // not get from server
  });

  factory ServiceDetailModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailModel(
      serviceId: ParseTypeData.ensureInt(json["serviceId"]),
      name: ParseTypeData.ensureString(json["name"]),
      price: ParseTypeData.ensureDouble(json["price"]),
      priceStr: ParseTypeData.ensureString(json["priceStr"]),
      image: ParseTypeData.ensureString(json["image"]),
      unit: ParseTypeData.ensureString(json["unit"]),
    );
  }

  static List<ServiceDetailModel> parseListItem(dynamic data) {
    List<ServiceDetailModel> list = [];
    if (data is List) {
      for (var item in data) {
        ServiceDetailModel model = ServiceDetailModel.fromJson(item);
        list.add(model);
      }
    }
    return list;
  }
}
