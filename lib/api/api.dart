import 'package:restaurant_flutter/api/http_manager.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/enum.dart';
import 'package:restaurant_flutter/models/service/dish.dart';
import 'package:restaurant_flutter/models/service/model_result_api.dart';
import 'package:restaurant_flutter/models/service/service.dart';
import 'package:restaurant_flutter/models/service/table.dart';
import 'package:restaurant_flutter/models/service/user.dart';

class Api {
  static final httpManager = HTTPManager();
  static const String https = "https://";
  static const String http = "http://";

  static String getProtocol() {
    const bool useSsl = false;
    String protocol = (useSsl ? Api.https : Api.http);
    return protocol;
  }

  static String localHost() {
    return "localhost:3005";
  }

  static String branchGetter() {
    String branch = getProtocol() + localHost();
    return branch;
  }

  static String appendBranch(String operation) {
    return "${branchGetter()}$operation";
  }

  static cancelRequest({String tag = ""}) {
    httpManager.cancelRequest(tag: tag);
  }

  static void cancelAllRequest() {
    httpManager.cancelAllRequest();
  }

  static String buildIncreaseTagRequestWithID(String identifier) {
    return "${identifier}_${DateTime.now()}";
  }

  static String loginUrl = "/account/login";
  static String logoutUrl = "/account/logout";
  static String signUpUrl = "/account/create";
  static String verifyOTPUrl = "/account/create/verify";
  //dish & drink screen
  static String requestDishUrl = "/dish/get";
  static String requestDishTypeUrl = "/dish/get/type";
  static String addDishUrl = "/manager/dish/create";

  //reservation
  static String requestCreateReservationUrl = "/reservation/create";
  static String requestAllReservationUrl = "/reservation/get/all";
  static String requestDetailReservationUrl = "/reservation/get/detail";

  //table
  static String requestTableUrl = "/table/get";
  static String requestTableTypeUrl = "/table/get/type/all";

  //service
  static String requestAllServiceUrl = "/service/get/all";
  static String addServiceUrl = "/manager/service/create";

  //chat
  static String requestConversationUrl = "/conversation";
  static String requestMessageUrl = "/message";
  static String requestClientMessageUrl = "/conversation/client/message";

  //authorization
  static Future<UserModel> requestLogin({
    String login = "",
    String password = "",
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    var params = {
      "login": login,
      "password": password,
    };
    final result = await httpManager.post(
      url: appendBranch(loginUrl),
      data: params,
      cancelTag: tagRequest,
    );
    return UserModel.fromJson(result);
  }

  static Future<ResultModel> requestSignUp({
    String email = "",
    String phone = "",
    String password = "",
    String userName = "",
    String birthDay = "",
    String address = "",
    GenderEnum gender = GenderEnum.male,
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    var params = {
      "email": email,
      "phone": phone,
      "password": password,
      "userName": userName,
      "birthDay": birthDay,
      "address": address,
      "gender": gender.value,
    };
    final result = await httpManager.post(
      url: appendBranch(signUpUrl),
      data: params,
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  static Future<ResultModel> verifyOTPSignUp({
    String login = "",
    String otp = "",
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    var params = {
      "login": login,
      "verifyOTP": otp,
    };
    final result = await httpManager.post(
      url: appendBranch(verifyOTPUrl),
      data: params,
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  //dish screen
  static Future<ResultModel> requestDish({
    int type = 0,
    int limit = kLimit,
    required page,
    required OrderEnum order,
    required bool isDrink,
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    String url = requestDishUrl;
    var params = {
      "type": type == 0 ? "" : type, //type = 0 => all => truyền "type" rỗng
      "limit": limit,
      "page": page,
      "order": order.value,
      "isDrink": isDrink ? 1 : 0,
    };
    final result = await httpManager.get(
      url: appendBranch(url),
      params: params,
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  static Future<ResultModel> requestDishType({
    required bool isDrinkType,
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    String url = requestDishTypeUrl;
    var params = {
      "isDrinkType": isDrinkType ? 1 : 0,
    };
    final result = await httpManager.get(
      url: appendBranch(url),
      params: params,
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  static Future<ResultModel> addDish({
    required String name,
    required String description,
    required String price,
    required String image,
    bool isDrink = false,
    required int dishTypeId,
    required String unit,
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    String url = addDishUrl;
    var data = {
      "name": name,
      "description": description,
      "price": price,
      "image": image,
      "isDrink": isDrink ? 1 : 0,
      "dishTypeId": dishTypeId,
      "unit": unit,
    };
    final result = await httpManager.post(
      url: appendBranch(url),
      data: data,
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  //table
  static Future<ResultModel> requestTable({
    required String datetime,
    String tableTypeId = "",
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    var params = {
      "datetime": datetime,
      "tableTypeId": tableTypeId,
    };
    final result = await httpManager.get(
      url: appendBranch(requestTableUrl),
      params: params,
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  static Future<ResultModel> requestTableType({
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    final result = await httpManager.get(
      url: appendBranch(requestTableTypeUrl),
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  //reservation
  static Future<ResultModel> requestCreateReservation({
    required List<DishDetailModel> dishes,
    required List<DishDetailModel> drinks,
    required List<ServiceDetailModel> services,
    required TableTypeDetailModel tableType,
    required int countGuest,
    required String schedule,
    String note = "",
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    var data = {
      "dishes": dishes.map((e) => e.dishId).toList().join(","),
      "dishQuantities": dishes.map((e) => e.quantity).toList().join(","),
      "drinks": drinks.map((e) => e.dishId).toList().join(","),
      "drinkQuantities": drinks.map((e) => e.quantity).toList().join(","),
      "services": services.map((e) => e.serviceId).toList().join(","),
      "serviceQuantities": services.map((e) => e.quantity).toList().join(","),
      "schedule": schedule,
      "countGuest": countGuest,
      "tableTypeId": tableType.tableTypeId,
      "note": note,
    };
    final result = await httpManager.post(
      url: appendBranch(requestCreateReservationUrl),
      data: data,
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  static Future<ResultModel> requestAllReservation({
    required String status,
    int limit = kLimit,
    required page,
    required OrderEnum order,
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    var data = {
      "status": status,
      "limit": limit,
      "page": page,
      "order": order.value,
    };
    final result = await httpManager.get(
      url: appendBranch(requestAllReservationUrl),
      params: data,
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  static Future<ResultModel> requestDetailReservation({
    required int reservationId,
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    final result = await httpManager.get(
      url: appendBranch("$requestDetailReservationUrl/$reservationId"),
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  //service
  static Future<ResultModel> requestListService({
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    final result = await httpManager.get(
      url: appendBranch(requestAllServiceUrl),
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  static Future<ResultModel> addService({
    required String name,
    required String price,
    required String image,
    required String unit,
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    String url = addServiceUrl;
    var data = {
      "name": name,
      "price": price,
      "image": image,
      "unit": unit,
    };
    final result = await httpManager.post(
      url: appendBranch(url),
      data: data,
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  static Future<ResultModel> requestDetailConversation({
    required int conversationId,
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    final result = await httpManager.get(
      url: appendBranch("$requestConversationUrl/$conversationId"),
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  static Future<ResultModel> requestListConversation({
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    final result = await httpManager.get(
      url: appendBranch(requestConversationUrl),
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  static Future<ResultModel> requestAcceptConversation({
    required int conversationId,
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    final result = await httpManager.patch(
      url: appendBranch("$requestConversationUrl/$conversationId"),
      cancelTag: tagRequest,
    );
    return ResultModel.fromJson(result);
  }

  static Future<ResultModel> requestCreateMessage({
    required int conversationId,
    required String content,
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
    var data = {
      "conversationId": conversationId,
      "content": content,
    };
    final result = await httpManager.post(
      url: appendBranch(requestMessageUrl),
      data: data,
    );
    return ResultModel.fromJson(result);
  }

  static Future<ResultModel> requestClientMessage({
    String tagRequest = HTTPManager.DEFAULT_CANCEL_TAG,
  }) async {
     final result = await httpManager.get(
      url: appendBranch(requestClientMessageUrl),
    );
    return ResultModel.fromJson(result);
  }
}
