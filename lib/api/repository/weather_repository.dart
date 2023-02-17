import 'package:weather_app/api/interfaces/network_call_interface.dart';
import 'package:weather_app/api/interfaces/weather_interface.dart';
import 'package:weather_app/api/keys/api_keys.dart';
import 'package:weather_app/api/models/weather_forcast/weather_model/weather_model.dart';
import 'package:weather_app/api/services/dio_service.dart';
import 'package:weather_app/api/utils/network_response.dart';

class WeatherRepository implements WeatherInterface {
  final NetworkApi _service = DioService();
  @override
  Future<NetworkResponse> getWeatherData({
    required double latitude,
    required double longitude,
  }) async {
    const url = ApiKeys.baseUrl + ApiKeys.weatherDetails;
    NetworkResponse errorResponse = NetworkResponse.error();
    try {
      final response = await _service.get(url: url, queryParameters: {
        "lat": latitude,
        "lon": longitude,
        "cnt": 50,
        "units": "metric",
        "appid": ApiKeys.apiKey,
      });
      if (response.success && response.data is Map) {
        return NetworkResponse.success(
            data: WeatherModel.fromMap(response.data),
            code: response.code,
            message: response.message);
      }
      return response;
    } catch (e) {
      return errorResponse
        ..message = "An error occured"
        ..success = false;
    }
  }
}
