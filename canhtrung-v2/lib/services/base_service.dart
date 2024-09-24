import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class BaseService {
  BaseService._();
  static final _instance = BaseService._();
  static BaseService get instance => _instance;

  static const baseUrl = ApiUrlV2.baseUrl;
  final _prefs = SharedPreferencesService();

  late final Dio _dio;
  Dio get dio => _dio;

  initalize() {
    if (_prefs.token != null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: {'Authorization': 'Bearer ${_prefs.token}'},
        ),
      );
    } else {
      _dio = Dio(BaseOptions(baseUrl: baseUrl));
    }

    _dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        options.connectTimeout = const Duration(milliseconds: 5000);
        options.receiveTimeout = const Duration(milliseconds: 5000);
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        return handler.next(response);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ));
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
          request: true, requestBody: true, requestHeader: true));
    }
  }

  addToken(String token) {
    _dio.options = _dio.options
        .copyWith(headers: {'Authorization': 'Bearer ${_prefs.token}'});
  }
}
