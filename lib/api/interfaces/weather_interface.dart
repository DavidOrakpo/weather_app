import 'package:weather_app/api/utils/network_response.dart';

/// A Base Class representing the required methods that the Weather Repository class should implement
abstract class WeatherInterface {
  /// Method signature to Retrieve data from the service class, given the latitude [latitude] and longitude [longitude]
  Future<NetworkResponse> getWeatherData(
      {required double latitude, required double longitude});
}
