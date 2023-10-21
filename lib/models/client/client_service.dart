import 'package:restaurant_flutter/models/service/service.dart';
import 'package:restaurant_flutter/utils/utils.dart';

class ClientServiceModel {
  final int total;
  final int maxPage;
  final int currentPage;
  final List<ServiceDetailModel> services;
  ClientServiceModel({
    this.total = 0,
    this.maxPage = 0,
    this.currentPage = 0,
    this.services = const [],
  });
  factory ClientServiceModel.fromJson(Map<String, dynamic> json) {
    return ClientServiceModel(
      total: ParseTypeData.ensureInt(json["total"]),
      maxPage: ParseTypeData.ensureInt(json["maxPage"]),
      currentPage: ParseTypeData.ensureInt(json["currentPage"]),
      services: ServiceDetailModel.parseListItem(json["rows"]),
    );
  }
}
