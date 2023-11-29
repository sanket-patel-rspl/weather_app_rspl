import 'package:first_test_project/modules/weather_module/presentation/screens/weather_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => const WeatherScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const WeatherScreen(),
        );
    }
  }
}
