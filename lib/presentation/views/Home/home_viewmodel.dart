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
    return HomePageViewModel(WeatherRepository());
  },
);

class HomePageViewModel with ChangeNotifier {
  final WeatherRepository _weatherRepository;
  HomePageViewModel(this._weatherRepository);

  Position? _usersLocation;
  Position? get usersLocation => _usersLocation;
  set usersLocation(Position? value) {
    _usersLocation = value;
    notifyListeners();
  }

  WeatherModel? _weatherModel;
  WeatherModel? get weatherModel => _weatherModel;
  set weatherModel(WeatherModel? value) {
    _weatherModel = value;
    notifyListeners();
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<ThreeHourSegmentsList>? selectedDaysAverage;

  DateTime? _selectedDate = DateTime.now();
  DateTime? get selectedDate => _selectedDate;

  set selectedDate(DateTime? value) {
    _selectedDate = value;
    notifyListeners();
  }

  String? _selectedDateIcon;
  String? get selectedDateIcon => _selectedDateIcon;

  set selectedDateIcon(String? value) {
    _selectedDateIcon = value;
    notifyListeners();
  }

  String? _selectedDateTitle = "Today";
  String? get selectedDateTitle => _selectedDateTitle;

  set selectedDateTitle(String? value) {
    _selectedDateTitle = value;
    notifyListeners();
  }

  String? _selectedDateDescription;
  String? get selectedDateDescription => _selectedDateDescription;

  set selectedDateDescription(String? value) {
    _selectedDateDescription = value;
    notifyListeners();
  }

  int? _onChangedDayIndex = 0;
  int? get onChangedDayIndex => _onChangedDayIndex;

  set onChangedDayIndex(int? value) {
    _onChangedDayIndex = value;
    notifyListeners();
  }

  double? _selectedDateTemperature = 0;
  double? get selectedDateTemperature => _selectedDateTemperature;

  set selectedDateTemperature(double? value) {
    _selectedDateTemperature = value;
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
    _isLoading = true;
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) async {
      await fetchData(position);
      getChosenDaysAverage();
      _isLoading = false;
      notifyListeners();
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  Future<void> fetchData(Position position) async {
    var result = await _weatherRepository.getWeatherData(
        latitude: position.latitude, longitude: position.longitude);
    if (!result.success) {
      NotificationManager.notifyError(result.message);
      return;
    }
    _weatherModel = result.data as WeatherModel;
    log("${_weatherModel?.city?.country}");
  }

  void getChosenDaysAverage({DateTime? chosenDate}) {
    _selectedDateTemperature = 0;
    if (chosenDate != null) {
      selectedDate = chosenDate;
      _selectedDateTitle =
          chosenDate.day != DateTime.now().day ? "Tomorrow" : "Today";
    }

    ///Get the Time Segments of the required day from the Model
    selectedDaysAverage =
        _weatherModel?.threeHourSegmentsList?.where((element) {
      var temp = DateTime.fromMillisecondsSinceEpoch(element.dt! * 1000);
      return temp.month == _selectedDate?.month &&
          temp.day == _selectedDate?.day;
    }).toList();

    ///Find the average of the temperatures amongst the time segments
    for (var threeHourSegment in selectedDaysAverage!) {
      _selectedDateTemperature =
          _selectedDateTemperature! + threeHourSegment.main!.temp!.toDouble();
    }
    log(_selectedDateTemperature.toString());
    _selectedDateTemperature =
        _selectedDateTemperature! / selectedDaysAverage!.length;
    var temp =
        selectedDaysAverage?[((selectedDaysAverage!.length) / 2).truncate()];
    _selectedDateDescription = temp?.weather?.first.description;
    _selectedDateIcon = temp?.weather?.first.icon;

    log(_selectedDateTemperature!.toStringAsFixed(2));

    // selectedDatesTemperature = selectedDaysAverage.
    log("${selectedDaysAverage?.length}");
  }
}
