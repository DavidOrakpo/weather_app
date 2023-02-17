import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/core/Alerts/context.dart';
import 'package:weather_app/core/Alerts/notification_manager.dart';

class Utilities {
  static Future<bool> handleLocationPermission() async {
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
}
