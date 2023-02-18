import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/api/models/weather_forcast/weather_model/weather_model.dart';
import 'package:weather_app/presentation/views/details/Model/detail_model.dart';

final detailsProvider = ChangeNotifierProvider(
  (ref) {
    return DetailsViewModel();
  },
);

class DetailsViewModel with ChangeNotifier {
  /// The list of DateTime objects, for 5 consecutive days
  final List<DateTime> _listOfDays = List.generate(5, (index) {
    return DateTime.now().add(Duration(days: index));
  });

  /// The list of weather information for the next 5 days
  List<DetailsModel>? daysDetailed = [];

  /// Computes the Daily Temperature Average for 5 consecutive days.
  ///
  /// The parameter [weatherModel] is supplied from the Home Page
  void computeTemperatureDailyAverage(WeatherModel weatherModel) {
    if (daysDetailed!.isNotEmpty) {
      daysDetailed?.clear();
    }
    for (var day in _listOfDays) {
      double sumOfDailyTemperatures = 0;
      var timeSegmentPerDay =
          weatherModel.threeHourSegmentsList?.where((element) {
        var temp = DateTime.fromMillisecondsSinceEpoch(element.dt! * 1000);
        return temp.month == day.month && temp.day == day.day;
      }).toList();

      if (timeSegmentPerDay!.isNotEmpty) {
        for (var threeHourSegment in timeSegmentPerDay) {
          sumOfDailyTemperatures =
              sumOfDailyTemperatures + threeHourSegment.main!.temp!.toDouble();
        }
        sumOfDailyTemperatures =
            sumOfDailyTemperatures / timeSegmentPerDay.length;

        var temp =
            timeSegmentPerDay[((timeSegmentPerDay.length) / 2).truncate()];
        daysDetailed!.add(DetailsModel(
            day, temp.weather!.first.icon!, sumOfDailyTemperatures));
      } else {
        daysDetailed!.add(DetailsModel(day, null, null));
      }
    }
  }
}
