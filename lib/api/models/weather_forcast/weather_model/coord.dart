import 'dart:convert';

class Coord {
  double? lat;
  double? lon;

  Coord({this.lat, this.lon});

  factory Coord.fromMap(Map<String, dynamic> data) => Coord(
        lat: (data['lat'] as num?)?.toDouble(),
        lon: (data['lon'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'lat': lat,
        'lon': lon,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Coord].
  factory Coord.fromJson(String data) {
    return Coord.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Coord] to a JSON string.
  String toJson() => json.encode(toMap());
}
