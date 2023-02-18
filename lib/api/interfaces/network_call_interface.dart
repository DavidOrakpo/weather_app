import 'package:weather_app/api/utils/network_response.dart';

/// A Base Class representing the required methods that any Service class should implement
abstract class NetworkApi {
  /// Handles GET requests made by the service class, taking the required url [url] and any
  /// possible query Parameters [queryParameters]
  Future<NetworkResponse> get({
    required String url,
    Map<String, dynamic>? queryParameters,
  });
}
