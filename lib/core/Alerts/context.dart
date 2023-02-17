import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._internal();
  static final AppNavigator instance = AppNavigator._internal();
  factory AppNavigator() {
    return instance;
  }

  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navKey => _navKey;
}
