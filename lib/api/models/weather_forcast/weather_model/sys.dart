import 'dart:convert';

class Sys {
  String? pod;

  Sys({this.pod});

  factory Sys.fromMap(Map<String, dynamic> data) => Sys(
        pod: data['pod'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'pod': pod,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Sys].
  factory Sys.fromJson(String data) {
    return Sys.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Sys] to a JSON string.
  String toJson() => json.encode(toMap());
}
