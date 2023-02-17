import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/api/models/weather_forcast/weather_model/three_hour_segments_list.dart';
import 'package:weather_app/api/models/weather_forcast/weather_model/weather_model.dart';
import 'package:weather_app/api/repository/weather_repository.dart';
import 'package:weather_app/core/Alerts/context.dart';
import 'package:weather_app/core/Alerts/notification_manager.dart';

final homeProvider = ChangeNotifierProvider(
  (ref) {
    return HomePageViewModel(weatherRepository: WeatherRepository());
  },
);

class HomePageViewModel with ChangeNotifier {
  final WeatherRepository weatherRepository;
  Position? _usersLocation;
  WeatherModel? _weatherModel;
  List<ThreeHourSegmentsList>? selectedDaysAverage;
  DateTime? selectedDate = DateTime.now();
  double? selectedDatesTemperature = 0;
  HomePageViewModel({required this.weatherRepository});
  Position? get usersLocation => _usersLocation;

  set usersLocation(Position? value) {
    _usersLocation = value;
    notifyListeners();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      NotificationManager.notifyError(
          "Location services are disabled. Please enable the services");

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        NotificationManager.notifyError("Location permissions are denied");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      NotificationManager.notifyError(
          "Location permissions are permanently denied, we cannot request permissions.");
      return false;
    }
    return true;
  }

  // static Future<Position> getGlobalPosition(String testString) async {
  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  Future<void> getUsersPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) async {
      await fetchData(position);
      getChosenDaysAverage();
      notifyListeners();
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  Future<void> fetchData(Position position) async {
    var result = await weatherRepository.getWeatherData(
        latitude: position.latitude, longitude: position.longitude);
    if (!result.success) {
      NotificationManager.notifyError(result.message);
      return;
    }
    _weatherModel = result.data as WeatherModel;
    log("${_weatherModel?.city?.country}");
  }

  void getChosenDaysAverage() {
    selectedDaysAverage =
        _weatherModel?.threeHourSegmentsList?.takeWhile((element) {
      var temp = DateTime.fromMillisecondsSinceEpoch(element.dt! * 1000);
      return temp.month == selectedDate?.month && temp.day == selectedDate?.day;
    }).toList();
    for (var threeHourSegment in selectedDaysAverage!) {
      selectedDatesTemperature =
          selectedDatesTemperature! + threeHourSegment.main!.temp!.toDouble();
    }
    selectedDatesTemperature =
        selectedDatesTemperature! / selectedDaysAverage!.length;
    log(selectedDatesTemperature!.toStringAsFixed(2));

    // selectedDatesTemperature = selectedDaysAverage.
    log("${selectedDaysAverage?.length}");
  }
}
