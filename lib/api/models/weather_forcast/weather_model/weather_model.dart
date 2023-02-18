import 'dart:convert';

import 'city.dart';
import 'three_hour_segments_list.dart';

/// A model class to encapsulate data retrieved from the API endpoint: [ApiKeys.weatherDetails]
class WeatherModel {
  String? cod;
  int? message;
  int? cnt;
  List<ThreeHourSegmentsList>? threeHourSegmentsList;
  City? city;

  WeatherModel(
      {this.cod,
      this.message,
      this.cnt,
      this.threeHourSegmentsList,
      this.city});

  factory WeatherModel.fromMap(Map<String, dynamic> data) => WeatherModel(
        cod: data['cod'] as String?,
        message: data['message'] as int?,
        cnt: data['cnt'] as int?,
        threeHourSegmentsList: (data['list'] as List<dynamic>?)
            ?.map(
                (e) => ThreeHourSegmentsList.fromMap(e as Map<String, dynamic>))
            .toList(),
        // .toList(),
        city: data['city'] == null
            ? null
            : City.fromMap(data['city'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'cod': cod,
        'message': message,
        'cnt': cnt,
        'list': threeHourSegmentsList?.map((e) {
          return (e) => e.toMap().toList();
        }).toList(),
        'city': city?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [WeatherModel].
  factory WeatherModel.fromJson(String data) {
    return WeatherModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [WeatherModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
