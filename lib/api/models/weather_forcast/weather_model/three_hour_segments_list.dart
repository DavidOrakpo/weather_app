import 'dart:convert';

import 'clouds.dart';
import 'main.dart';
import 'sys.dart';
import 'weather.dart';
import 'wind.dart';

class ThreeHourSegmentsList {
  int? dt;
  Main? main;
  List<Weather>? weather;
  Clouds? clouds;
  Wind? wind;
  int? visibility;
  double? pop;
  Sys? sys;
  String? dtTxt;

  ThreeHourSegmentsList({
    this.dt,
    this.main,
    this.weather,
    this.clouds,
    this.wind,
    this.visibility,
    this.pop,
    this.sys,
    this.dtTxt,
  });

  factory ThreeHourSegmentsList.fromMap(Map<String, dynamic> data) =>
      ThreeHourSegmentsList(
        dt: data['dt'] as int?,
        main: data['main'] == null
            ? null
            : Main.fromMap(data['main'] as Map<String, dynamic>),
        weather: (data['weather'] as List<dynamic>?)
            ?.map((e) => Weather.fromMap(e as Map<String, dynamic>))
            .toList(),
        clouds: data['clouds'] == null
            ? null
            : Clouds.fromMap(data['clouds'] as Map<String, dynamic>),
        wind: data['wind'] == null
            ? null
            : Wind.fromMap(data['wind'] as Map<String, dynamic>),
        visibility: data['visibility'] as int?,
        pop: (data['pop'] as num?)?.toDouble(),
        sys: data['sys'] == null
            ? null
            : Sys.fromMap(data['sys'] as Map<String, dynamic>),
        dtTxt: data['dt_txt'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'dt': dt,
        'main': main?.toMap(),
        'weather': weather?.map((e) => e.toMap()).toList(),
        'clouds': clouds?.toMap(),
        'wind': wind?.toMap(),
        'visibility': visibility,
        'pop': pop,
        'sys': sys?.toMap(),
        'dt_txt': dtTxt,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [List].
  factory ThreeHourSegmentsList.fromJson(String data) {
    return ThreeHourSegmentsList.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [List] to a JSON string.
  String toJson() => json.encode(toMap());
}
