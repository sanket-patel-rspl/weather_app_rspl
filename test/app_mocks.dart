// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:first_test_project/modules/weather_module/application/usecases/weather_usecases.dart';
import 'package:first_test_project/modules/weather_module/data/weather_network_source.dart';
import 'package:first_test_project/modules/weather_module/domain/repository/weather_repository.dart';
import 'package:mocktail/mocktail.dart';

/// Mock classes of Weather_Module
class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockWeatherUseCases extends Mock implements WeatherUseCases {}

class MockWeatherDataSource extends Mock implements WeatherDataSource {}
