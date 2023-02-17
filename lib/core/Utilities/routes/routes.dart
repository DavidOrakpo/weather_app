import 'package:go_router/go_router.dart';
import 'package:weather_app/api/models/weather_forcast/weather_model/weather_model.dart';
import 'package:weather_app/core/Alerts/context.dart';
import 'package:weather_app/core/Utilities/Transitions/transitions.dart';
import 'package:weather_app/presentation/views/Home/home_page.dart';
import 'package:weather_app/presentation/views/details/details.dart';

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
        routes: [
          GoRoute(
            name: DetailsPage.routeIdentifier,
            path: "detailsPage",
            builder: (context, state) =>
                DetailsPage(weatherModel: state.extra as WeatherModel),
            pageBuilder: (context, state) {
              return CustomSlideTransition(
                  key: state.pageKey,
                  child:
                      DetailsPage(weatherModel: state.extra as WeatherModel));
            },
          ),
        ],
      )
    ],
  );
}
