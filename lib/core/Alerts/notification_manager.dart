import 'package:flutter/material.dart';
import 'package:weather_app/core/Alerts/context.dart';

class NotificationManager {
  static void notifySuccess(String message) {
    _showSnackBar(
        Colors.green, AppNavigator.instance.navKey.currentContext!, message);
  }

  static void notifyError(String message) {
    _showSnackBar(
        Colors.red, AppNavigator.instance.navKey.currentContext!, message);
  }

  static void notifyInfo(String message) {
    _showSnackBar(Colors.blue.shade900,
        AppNavigator.instance.navKey.currentContext!, message);
  }

  static void _showSnackBar(Color color, BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: color,
          content: Text(message),
          dismissDirection: DismissDirection.down,
          margin: const EdgeInsets.all(8),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
