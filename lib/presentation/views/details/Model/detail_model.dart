import 'package:flutter/material.dart';

/// A concise representation of values needed to generate the Details Page
class DetailsModel {
  /// The day of the week
  final DateTime day;

  /// The weather icon depicting the average day's temperature
  final String? icon;

  /// The average temperature of the day
  final double? temperature;

  DetailsModel(this.day, this.icon, this.temperature);
}
