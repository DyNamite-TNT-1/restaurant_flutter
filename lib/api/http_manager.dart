import 'package:dio/dio.dart';
import 'package:restaurant_flutter/configs/configs.dart';
import 'package:restaurant_flutter/utils/utils.dart';

class HTTPManager {
  late final Dio dioInternal;
  late final Dio dioExternal;

  static const String DEFAULT_CANCEL_TAG = "DEFAULT_CANCEL_TAG";

  static const int _TIMEOUTNORMAL = 30000;
  static const int _TIMEOUTDOWNLOADUPLOAD = 1200 * 1000; //20'

  final List<String> rejectCode = [
    'jwt expired',
    'un_authorized',
    'user_not_found'
  ];

  Map<String, CancelToken> cancelTokenMap = {};

  BaseOptions options = BaseOptions(
    connectTimeout: Duration(milliseconds: _TIMEOUTNORMAL),
    receiveTimeout: Duration(milliseconds: _TIMEOUTNORMAL),
    responseType: ResponseType.json,
  );

  HTTPManager() {
    ///Dio internal
    dioInternal = Dio(_defaultOptions());

    ///Dio external
    dioExternal = Dio(
      BaseOptions(
        baseUrl: "",
        connectTimeout: Duration(milliseconds: _TIMEOUTNORMAL),
        receiveTimeout: Duration(milliseconds: _TIMEOUTNORMAL),
        responseType: ResponseType.json,
      ),
    );
  }

  BaseOptions _defaultOptions() {
    final Map<String, dynamic> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      // 'DEVICE_TYPE': Platform.isAndroid ? 'android' : 'ios',
      // 'DEVICE': 'phone',
      // 'device': 'phone',
      // 'device_id': '1e10f743-196e-4bc0-aee7-8c14690f2ac4',
    };

    options.headers = Map.from(headers);
    return options;
  }

  BaseOptions _optionsCookie() {
    final token = UserPreferences.getToken();
    if (token != null) {
      options.headers['access_token'] = token;
    }

    return options;
  }

  void cancelRequest({String tag = ""}) {
    if (tag.isNotEmpty) {
      CancelToken? token = cancelTokenMap[tag];
      if (token != null) {
        token.cancel();
      }
      cancelTokenMap.remove(tag);
    }
  }

  void cancelAllRequest() {
    cancelTokenMap.values.forEach((element) {
      element.cancel();
    });

    cancelTokenMap.clear();
  }

  ///Post method
  Future<dynamic> post({
    required String url,
    Map<String, dynamic>? data,
    FormData? formData,
    Options? options,
    bool external = false,
    Function? callBack,
    String cancelTag = DEFAULT_CANCEL_TAG,
  }) async {
    Dio request = dioInternal;
    if (external) {
      request = dioExternal;
    }

    request.options = _optionsCookie();
    dioInternal.options.method = 'POST';
    dioInternal.options.headers['Content-Type'] =
        "application/json; charset=UTF-8";
    final requestUrl = url;

    try {
      CancelToken cancelToken = CancelToken();
      cancelTokenMap[cancelTag] = cancelToken;

      UtilLogger.log("====================================");
      UtilLogger.log('Request POST', requestUrl);
      UtilLogger.log('PARAMS:', data);
      UtilLogger.log('REQUEST OPTIONS:', request.options.receiveTimeout);

      final Response<dynamic> response;

      if (formData != null) {
        response = await request.post(
          requestUrl,
          data: formData,
          options: options,
          cancelToken: cancelToken,
        );
      } else {
        response = await request.post(
          requestUrl,
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: (count, total) {
            if (callBack != null) {
              callBack(count, total, cancelTag);
            }
          },
        );
      }

      cancelTokenMap.remove(cancelTag);
      UtilLogger.log('RESPONSE ${response.realUri}: \n', response.data);
      return response.data;
    } on DioException catch (error) {
      if (CancelToken.isCancel(error)) {
        return null;
      }
      cancelTokenMap.remove(cancelTag);
      UtilLogger.log('EXCEPTION POST $url: \n', error);
      return errorHandle(error);
    }
  }

  ///PUT method
  Future<dynamic> put({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? params,
    FormData? formData,
    Options? options,
    bool external = false,
    Function? callBack,
    String cancelTag = DEFAULT_CANCEL_TAG,
  }) async {
    Dio request = dioInternal;
    if (external) {
      request = dioExternal;
    }

    request.options = _optionsCookie();
    dioInternal.options.method = 'PUT';
    dioInternal.options.headers['Content-Type'] =
        "application/json; charset=UTF-8";
    final requestUrl = url;

    try {
      CancelToken cancelToken = CancelToken();
      cancelTokenMap[cancelTag] = cancelToken;

      UtilLogger.log("====================================");
      UtilLogger.log('Request PUT', requestUrl);
      if (params != null) {
        UtilLogger.log('PARAMS:', params);
      } else {
        UtilLogger.log('BODY:', data);
      }
      UtilLogger.log('REQUEST PUT:', request.options.receiveTimeout);

      final Response<dynamic> response;

      if (formData != null) {
        response = await request.put(
          requestUrl,
          data: formData,
          options: options,
          cancelToken: cancelToken,
        );
      } else if (params != null) {
        response = await request.put(
          requestUrl,
          queryParameters: params,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: (count, total) {
            if (callBack != null) {
              callBack(count, total, cancelTag);
            }
          },
        );
      } else {
        response = await request.put(
          requestUrl,
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: (count, total) {
            if (callBack != null) {
              callBack(count, total, cancelTag);
            }
          },
        );
      }

      cancelTokenMap.remove(cancelTag);
      UtilLogger.log('RESPONSE ${response.realUri}: \n', response.data);
      return response.data;
    } on DioException catch (error) {
      if (CancelToken.isCancel(error)) {
        return null;
      }
      cancelTokenMap.remove(cancelTag);
      UtilLogger.log('EXCEPTION PUT $url: \n', error);
      return errorHandle(error);
    }
  }

  ///Get method
  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? params,
    Options? options,
    bool external = false,
    String cancelTag = DEFAULT_CANCEL_TAG,
  }) async {
    Dio request = dioInternal;
    if (external) {
      request = dioExternal;
    }

    request.options = _optionsCookie();
    dioInternal.options.method = 'GET';
    final requestUrl = url;
    try {
      CancelToken cancelToken = CancelToken();
      cancelTokenMap[cancelTag] = cancelToken;

      UtilLogger.log("====================================");
      UtilLogger.log('REQUEST GET', requestUrl);
      UtilLogger.log('PARAMS:', params);
      UtilLogger.log('TIMEOUT:', request.options.receiveTimeout);

      final response = await request.get(
        requestUrl,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken,
      );

      cancelTokenMap.remove(cancelTag);
      UtilLogger.log('RESPONSE ${response.realUri}: \n', response.data);
      return response.data;
    } on DioError catch (error) {
      if (CancelToken.isCancel(error)) {
        // print("GET REQUEST CANCEL $error");
        return null;
      }
      cancelTokenMap.remove(cancelTag);
      UtilLogger.log('EXCEPTION GET $requestUrl: \n', error);
      return errorHandle(error);
    }
  }

  ///delete method
  Future<dynamic> delete({
    required String url,
    Map<String, dynamic>? params,
    Options? options,
    bool external = false,
    String cancelTag = DEFAULT_CANCEL_TAG,
  }) async {
    Dio request = dioInternal;
    if (external) {
      request = dioExternal;
    }

    request.options = _optionsCookie();
    dioInternal.options.method = 'GET';
    final requestUrl = url;
    try {
      CancelToken cancelToken = CancelToken();
      cancelTokenMap[cancelTag] = cancelToken;

      final response = await request.delete(
        requestUrl,
        queryParameters: params,
        options: options,
        cancelToken: cancelToken,
      );

      cancelTokenMap.remove(cancelTag);
      UtilLogger.log("====================================");
      UtilLogger.log('REQUEST GET', requestUrl);
      UtilLogger.log('PARAMS:', params);
      UtilLogger.log('RESPONSE $requestUrl: \n', response.data);
      return response.data;
    } on DioError catch (error) {
      if (CancelToken.isCancel(error)) {
        // print("GET REQUEST CANCEL $error");
        return null;
      }
      cancelTokenMap.remove(cancelTag);
      UtilLogger.log('EXCEPTION GET $requestUrl: \n', error);
      return errorHandle(error);
    }
  }

  ///Print request info
  void printRequest(RequestOptions options) {
    UtilLogger.log("BEFORE REQUEST ====================================");
    UtilLogger.log("${options.method} URL", options.path);
    UtilLogger.log("HEADERS", options.headers);
    if (options.method == 'GET') {
      UtilLogger.log("PARAMS", options.queryParameters);
    } else {
      UtilLogger.log("DATA", options.data);
    }
  }

  ///Error common handle
  Map<String, dynamic> errorHandle(DioException error) {
    String message = "unknown_error";
    dynamic data = <String, dynamic>{};

    switch (error.type) {
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = "request_time_out";
        break;
      case DioExceptionType.badResponse:
        data = error.response?.data ?? <String, dynamic>{};
        if (data is Map) {
          var serverMsg = ParseTypeData.ensureString(data["msg"]);
          message = serverMsg.isEmpty ? message : serverMsg;
        }
        if (error.response?.statusCode == 401) {
          // move to login page
          // AppBloc.authenticationBloc.add(OnAuthenticationLogout(
          //   ignoreApi: true,
          //   timeout: 0,
          //   errorMessage: message.isEmpty ? "token_expired" : message,
          // ));
        }

        break;

      default:
        message = "cannot_connect_server";
        break;
    }

    return {
      "success": false,
      "message": message,
      "msg": message,
      "data": data,
    };
  }
}
