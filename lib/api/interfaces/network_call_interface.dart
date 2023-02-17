import 'package:weather_app/api/utils/network_response.dart';

abstract class NetworkApi {
  Future<NetworkResponse> get({
    required String url,
    Map<String, dynamic>? queryParameters,
  });
}
