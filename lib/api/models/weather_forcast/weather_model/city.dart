import 'dart:convert';

import 'coord.dart';

class City {
  int? id;
  String? name;
  Coord? coord;
  String? country;
  int? population;
  int? timezone;
  int? sunrise;
  int? sunset;

  City({
    this.id,
    this.name,
    this.coord,
    this.country,
    this.population,
    this.timezone,
    this.sunrise,
    this.sunset,
  });

  factory City.fromMap(Map<String, dynamic> data) => City(
        id: data['id'] as int?,
        name: data['name'] as String?,
        coord: data['coord'] == null
            ? null
            : Coord.fromMap(data['coord'] as Map<String, dynamic>),
        country: data['country'] as String?,
        population: data['population'] as int?,
        timezone: data['timezone'] as int?,
        sunrise: data['sunrise'] as int?,
        sunset: data['sunset'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'coord': coord?.toMap(),
        'country': country,
        'population': population,
        'timezone': timezone,
        'sunrise': sunrise,
        'sunset': sunset,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [City].
  factory City.fromJson(String data) {
    return City.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [City] to a JSON string.
  String toJson() => json.encode(toMap());
}
