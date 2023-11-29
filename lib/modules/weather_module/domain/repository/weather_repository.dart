import 'package:first_test_project/modules/weather_module/domain/models/weather_response_model.dart';

abstract class WeatherRepository {
  Future<WeatherResponse> getWeatherData(double lat, double long);
}
