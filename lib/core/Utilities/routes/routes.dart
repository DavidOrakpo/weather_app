import 'package:go_router/go_router.dart';
import 'package:weather_app/core/Alerts/context.dart';
import 'package:weather_app/presentation/views/Home/home_page.dart';

class AppRoutes {
  AppRoutes._internal();
  static final AppRoutes instance = AppRoutes._internal();
  factory AppRoutes() {
    return instance;
  }
  final GoRouter router = GoRouter(
    navigatorKey: AppNavigator.instance.navKey,
    routes: [
      GoRoute(
        path: "/",
        name: HomePage.routeIdentifier,
        builder: (context, state) => const HomePage(),
      )
    ],
  );
}
