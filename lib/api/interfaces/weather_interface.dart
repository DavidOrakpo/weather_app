import 'package:weather_app/api/utils/network_response.dart';

abstract class WeatherInterface {
  Future<NetworkResponse> getWeatherData(
      {required double latitude, required double longitude});
}
