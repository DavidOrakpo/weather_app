import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:weather_app/api/interfaces/network_call_interface.dart';
import 'package:weather_app/api/keys/api_keys.dart';
import 'package:weather_app/api/utils/network_response.dart';

class DioService extends NetworkApi {
  late Dio _dioClient;
  DioService._initialize() {
    _dioClient = Dio(
      BaseOptions(
        // baseUrl: ApiKeys.baseUrl,
        headers: {
          Headers.acceptHeader: Headers.jsonContentType,
        },
        connectTimeout: const Duration(seconds: 40),
      ),
    )..interceptors.add(addInterceptors());
  }

  static final DioService _instance = DioService._initialize();
  factory DioService() => _instance;

  @override
  Future<NetworkResponse> get({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    var result = NetworkResponse.warning();
    try {
      final response =
          await _dioClient.get(url, queryParameters: queryParameters);
      result = _handleResponse(response);
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.badResponse:
          result.code = e.response!.statusCode!;
          result.success = false;
          result.message =
              e.response!.data["message"] ?? e.response!.statusMessage!;
          break;
        default:
      }
    } finally {
      _dioClient.close();
    }
    return result;
  }

  NetworkResponse _handleResponse(Response<dynamic> response) {
    NetworkResponse _result = NetworkResponse.warning();
    final data = response.data;
    if (response.statusCode == 200 || response.statusCode == 201) {
      _result = NetworkResponse.success(
        message: "success",
        data: data,
      );
    } else {
      _result.code = response.statusCode!;
      _result.message = data["message"] ?? "An error occured";
      _result.data = data;
    }
    return _result;
  }

  InterceptorsWrapper addInterceptors() {
    var interceptor = InterceptorsWrapper(onError: (e, handler) async {
      switch (e.type) {
        case DioErrorType.receiveTimeout:
          log("The error is Receive Timeout. Message is ${e.message}");
          break;
        case DioErrorType.connectionTimeout:
          log("The error is connectTimeout. Message is ${e.message}");
          break;
        case DioErrorType.badResponse:
          // log("The error is response. Message is ${e.message} ");
          // log("The error is response. Response is ${e.response} ");
          // log("The error is response. Message is ${e.response?.statusCode} ");
          // if (e.response?.statusCode == 502) {
          //   log("502 error from interceptor");
          // }
          break;
        case DioErrorType.cancel:
          log("The error is cancel. Message is ${e.message}");
          break;
        case DioErrorType.sendTimeout:
          log("The error is send. Message is ${e.message}");
          break;

        default:
      }

      return handler.next(e);
    }, onRequest: (request, handler) {
      return handler.next(request);
    }, onResponse: (response, handler) {
      return handler.next(response);
    });
    return interceptor;
  }
}
