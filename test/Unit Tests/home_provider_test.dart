import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_app/api/models/weather_forcast/weather_model/city.dart';
import 'package:weather_app/api/models/weather_forcast/weather_model/weather_model.dart';
import 'package:weather_app/api/repository/weather_repository.dart';
import 'package:weather_app/api/utils/network_response.dart';
import 'package:weather_app/presentation/views/Home/home_viewmodel.dart';

// class MockHomePageViewModel extends Mock implements HomePageViewModel {}

class MockWeatherRepository extends Mock implements WeatherRepository {}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  ProviderContainer createProviderContainer(
      MockWeatherRepository mockWeatherRepository) {
    final container = ProviderContainer(overrides: [
      repositoryProvider.overrideWith((ref) => mockWeatherRepository),
    ]);
    addTearDown(container.dispose);
    return container;
  }

  test(
    "Tests Fetch Data method",
    () async {
      /// Instance of Mock Weather Repository
      final weatherRepository = MockWeatherRepository();

      /// Provider container where we overide the repository provider
      final container = createProviderContainer(weatherRepository);

      final listener = Listener<HomePageViewModel>();

      container.listen(
        homeProvider,
        listener,
        fireImmediately: true,
      );

      const mockLatitude = 6.5;
      const mockLongitude = 3.3;

      final mockNetworkResponse = NetworkResponse.success(
        message: "Mock response from when callback",
        data: WeatherModel(
          city: City(),
          cnt: 5,
          cod: "200",
          message: 2,
        ),
      );

      /// Arange
      when(
        () => weatherRepository.getWeatherData(
            latitude: mockLatitude, longitude: mockLongitude),
      ).thenAnswer((invocation) => Future.value(mockNetworkResponse));

      final viewModel = container.read(homeProvider);
      viewModel.weatherModel = WeatherModel(
        city: City(),
        cnt: 5,
        cod: "200",
        message: 2,
      );

      /// Act
      await viewModel.fetchData(
        Position(
            longitude: mockLongitude,
            latitude: mockLatitude,
            timestamp: DateTime.now(),
            accuracy: 1,
            altitude: 1,
            heading: 1,
            speed: 1,
            speedAccuracy: 1),
      );

      /// Assert

      // Expects created status code to be returned
      expect((mockNetworkResponse.data as WeatherModel).cod,
          viewModel.weatherModel!.cod);
    },
  );
}
