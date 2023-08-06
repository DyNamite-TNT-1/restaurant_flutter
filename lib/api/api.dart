import 'package:restaurant_flutter/api/http_manager.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/enum/order.dart';
import 'package:restaurant_flutter/models/service/dish.dart';
import 'package:restaurant_flutter/models/service/dish_type.dart';
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
  //dish screen
  static String requestDishUrl = "/dish/get";
  static String requestDishTypeUrl = "/dish/get/type";

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

  //dish screen
  static Future<DishModel> requestDish({
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
    return DishModel.fromJson(result);
  }

  static Future<DishTypeFilterModel> requestDishType({
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
    return DishTypeFilterModel.fromJson(result);
  }
}
