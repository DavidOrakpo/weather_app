import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:weather_app/api/interfaces/network_call_interface.dart';
import 'package:weather_app/api/keys/api_keys.dart';
import 'package:weather_app/api/utils/network_response.dart';

/// This class handles direct communication with the API to retrieve data needed by the app
///
/// It performs a GET request using [get], encapsulates the response in [_handleResponse], and handles errors in the
/// [addInterceptors] method
class DioService extends NetworkApi {
  late Dio _dioClient;
  DioService._initialize() {
    _dioClient = Dio(
      BaseOptions(
        headers: {
          Headers.acceptHeader: Headers.jsonContentType,
        },
        connectTimeout: const Duration(seconds: 40),
      ),
    )..interceptors.add(addInterceptors());
  }

  static final DioService _instance = DioService._initialize();
  factory DioService() => _instance;

  /// Performs get requests, taking in a url [url], and any needed query parameters [queryParameters]
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

  /// Wraps the response gotten from the API in the [NetworkResponse] class
  NetworkResponse _handleResponse(Response<dynamic> response) {
    NetworkResponse result = NetworkResponse.warning();
    final data = response.data;
    if (response.statusCode == 200 || response.statusCode == 201) {
      result = NetworkResponse.success(
        message: "success",
        data: data,
      );
    } else {
      result.code = response.statusCode!;
      result.message = data["message"] ?? "An error occured";
      result.data = data;
    }
    return result;
  }

  /// Watches for any errors that may result when the end points are called.
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
