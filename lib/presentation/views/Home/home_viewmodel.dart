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
  HomePageViewModel(this._weatherRepository);

  /// The connection to the Weather Repository, where the API calls are made
  final WeatherRepository _weatherRepository;

  WeatherModel? _weatherModel;

  /// The data retrieved from the API.
  WeatherModel? get weatherModel => _weatherModel;
  set weatherModel(WeatherModel? value) {
    _weatherModel = value;
    notifyListeners();
  }

  bool _isLoading = true;

  /// Whether verification and initialization is complete
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// The Store of weather values (3 - Hour Segments) for the selected day
  List<ThreeHourSegmentsList>? threeHourSegmentsDayList = [];

  DateTime? _selectedDate = DateTime.now();

  /// The selected date by the end user
  DateTime? get selectedDate => _selectedDate;
  set selectedDate(DateTime? value) {
    _selectedDate = value;
    notifyListeners();
  }

  String? _selectedDateIcon;

  /// The selected weather Icon
  String? get selectedDateIcon => _selectedDateIcon;
  set selectedDateIcon(String? value) {
    _selectedDateIcon = value;
    notifyListeners();
  }

  bool? _locationServiceEnabled = false;

  /// Whether locations Services are active
  bool? get locationServiceEnabled => _locationServiceEnabled;
  set locationServiceEnabled(bool? value) {
    _locationServiceEnabled = value;
    notifyListeners();
  }

  String? _selectedDateTitle = "Today";

  /// The selected day Title
  String? get selectedDateTitle => _selectedDateTitle;
  set selectedDateTitle(String? value) {
    _selectedDateTitle = value;
    notifyListeners();
  }

  String? _selectedDateDescription;

  /// The selected dates weather description
  String? get selectedDateDescription => _selectedDateDescription;
  set selectedDateDescription(String? value) {
    _selectedDateDescription = value;
    notifyListeners();
  }

  int? _onChangedDayIndex = 0;

  /// Tracks whether Today or Tomorrow is selected
  int? get onChangedDayIndex => _onChangedDayIndex;
  set onChangedDayIndex(int? value) {
    _onChangedDayIndex = value;
    notifyListeners();
  }

  double? _selectedDateTemperature = 0;

  /// The selected Dates Temperature
  double? get selectedDateTemperature => _selectedDateTemperature;
  set selectedDateTemperature(double? value) {
    _selectedDateTemperature = value;
    notifyListeners();
  }

  /// Requests location permission from the user
  ///
  /// Informs the user if location services are active or not.
  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;

    locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locationServiceEnabled!) {
      NotificationManager.notifyError(
          "Location services are disabled. Please enable the services and try again");

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

  /// Performs initial setup and proceeds to make the API calls
  ///
  /// Checks if [_handleLocationPermission] is successful,
  /// proceeds to get the users location, then retrieves weather data from [_fetchData]
  Future<void> initialize() async {
    _isLoading = true;
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) async {
      await _fetchData(position);
      getChosenDaysAverage();
      _isLoading = false;
      notifyListeners();
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  /// Retrieves Weather information from the [_weatherRepository.getWeatherData]
  Future<void> _fetchData(Position position) async {
    var result = await _weatherRepository.getWeatherData(
        latitude: position.latitude, longitude: position.longitude);
    if (!result.success) {
      NotificationManager.notifyError(result.message);
      return;
    }
    _weatherModel = result.data as WeatherModel;
    log("${_weatherModel?.city?.country}");
  }

  /// Computes the average temperature of the users selected date: [selectedDate]
  void getChosenDaysAverage({DateTime? chosenDate}) {
    _selectedDateTemperature = 0;
    if (chosenDate != null) {
      selectedDate = chosenDate;
      _selectedDateTitle =
          chosenDate.day != DateTime.now().day ? "Tomorrow" : "Today";
    }

    //Get the Time Segments of the required day from the Model
    threeHourSegmentsDayList =
        _weatherModel?.threeHourSegmentsList?.where((element) {
      var temp = DateTime.fromMillisecondsSinceEpoch(element.dt! * 1000);
      return temp.month == _selectedDate?.month &&
          temp.day == _selectedDate?.day;
    }).toList();

    if (threeHourSegmentsDayList!.isEmpty) {
      return;
    }

    //Find the average of the temperatures amongst the time segments
    for (var threeHourSegment in threeHourSegmentsDayList!) {
      _selectedDateTemperature =
          _selectedDateTemperature! + threeHourSegment.main!.temp!.toDouble();
    }
    _selectedDateTemperature =
        _selectedDateTemperature! / threeHourSegmentsDayList!.length;
    var temp = threeHourSegmentsDayList?[
        ((threeHourSegmentsDayList!.length) / 2).truncate()];
    _selectedDateDescription = temp?.weather?.first.description;
    _selectedDateIcon = temp?.weather?.first.icon;
  }
}
