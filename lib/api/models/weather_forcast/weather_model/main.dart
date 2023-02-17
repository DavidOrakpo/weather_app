import 'dart:convert';

class Main {
  double? temp;
  double? feelsLike;
  double? tempMin;
  double? tempMax;
  int? pressure;
  int? seaLevel;
  int? grndLevel;
  int? humidity;
  double? tempKf;

  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.seaLevel,
    this.grndLevel,
    this.humidity,
    this.tempKf,
  });

  factory Main.fromMap(Map<String, dynamic> data) => Main(
        temp: (data['temp'] as num?)?.toDouble(),
        feelsLike: (data['feels_like'] as num?)?.toDouble(),
        tempMin: (data['temp_min'] as num?)?.toDouble(),
        tempMax: (data['temp_max'] as num?)?.toDouble(),
        pressure: data['pressure'] as int?,
        seaLevel: data['sea_level'] as int?,
        grndLevel: data['grnd_level'] as int?,
        humidity: data['humidity'] as int?,
        tempKf: (data['temp_kf'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'temp': temp,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'pressure': pressure,
        'sea_level': seaLevel,
        'grnd_level': grndLevel,
        'humidity': humidity,
        'temp_kf': tempKf,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Main].
  factory Main.fromJson(String data) {
    return Main.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Main] to a JSON string.
  String toJson() => json.encode(toMap());
}
