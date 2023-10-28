import 'package:flutter/material.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/dish.dart';
import 'package:restaurant_flutter/models/service/service.dart';
import 'package:restaurant_flutter/models/service/table.dart';
import 'package:restaurant_flutter/models/service/user.dart';
import 'package:restaurant_flutter/utils/parse_type_value.dart';

class ReservationDetailModel {
  final int reservationId;
  final int countGuest;
  final String note;
  final String managerNote;
  final int status;
  final String createAt;
  final String schedule;
  final int preFee;
  final String preFeeStr;
  final String deadline;
  final UserModel? userModel;
  final List<DishDetailModel> menus;
  final List<TableDetailModel> tables;
  final List<ServiceDetailModel> services;

  ReservationDetailModel({
    this.reservationId = 0,
    this.preFee = 0,
    this.preFeeStr = "",
    this.deadline = "",
    this.countGuest = 0,
    this.note = "",
    this.managerNote = "",
    this.status = 0,
    this.createAt = "",
    this.schedule = "",
    this.userModel,
    this.menus = const [],
    this.tables = const [],
    this.services = const [],
  });

  String get statusStr {
    return ReservationStatus.all
        .firstWhere((element) => element.value == status)
        .name;
  }

  Color get statusColor {
    return ReservationStatus.all
        .firstWhere((element) => element.value == status)
        .color;
  }

  List<DishDetailModel> get dishes {
    if (menus.isEmpty) {
      return [];
    } else {
      return menus.where((element) => !element.isDrink).toList();
    }
  }

   List<DishDetailModel> get drinks {
    if (menus.isEmpty) {
      return [];
    } else {
      return menus.where((element) => element.isDrink).toList();
    }
  }

  factory ReservationDetailModel.fromJson(Map<String, dynamic> json) {
    return ReservationDetailModel(
      reservationId: ParseTypeData.ensureInt(json["reservationId"]),
      preFee: ParseTypeData.ensureInt(json["preFee"]),
      preFeeStr: ParseTypeData.ensureString(json["preFeeStr"]),
      deadline: ParseTypeData.ensureString(json["deadline"]),
      countGuest: ParseTypeData.ensureInt(json["countGuest"]),
      note: ParseTypeData.ensureString(json["note"]),
      createAt: ParseTypeData.ensureString(json["createAt"]),
      managerNote: ParseTypeData.ensureString(json["managerNote"]),
      schedule: ParseTypeData.ensureString(json["schedule"]),
      status: ParseTypeData.ensureInt(json["status"]),
      userModel:
          json.containsKey("user") ? UserModel.fromJson(json["user"]) : null,
      menus: DishDetailModel.parseListItem(json["menus"]),
      tables: TableDetailModel.parseListItem(json["tables"]),
      services: ServiceDetailModel.parseListItem(json["services"]),
    );
  }

  static List<ReservationDetailModel> parseListItem(dynamic data) {
    List<ReservationDetailModel> list = [];
    if (data is List) {
      for (var item in data) {
        ReservationDetailModel model = ReservationDetailModel.fromJson(item);
        list.add(model);
      }
    }
    return list;
  }
}

class ReservationListModel {
  final int total;
  final int maxPage;
  final int currentPage;
  final List<ReservationDetailModel> reservations;
  ReservationListModel({
    this.total = 0,
    this.maxPage = 0,
    this.currentPage = 0,
    this.reservations = const [],
  });
  factory ReservationListModel.fromJson(Map<String, dynamic> json) {
    return ReservationListModel(
      total: ParseTypeData.ensureInt(json["total"]),
      maxPage: ParseTypeData.ensureInt(json["maxPage"]),
      currentPage: ParseTypeData.ensureInt(json["currentPage"]),
      reservations: ReservationDetailModel.parseListItem(json["rows"]),
    );
  }
}
