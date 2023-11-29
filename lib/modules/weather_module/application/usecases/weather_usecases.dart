import 'package:first_test_project/modules/weather_module/domain/repository/weather_repository.dart';

import '../../domain/models/weather_response_model.dart';

class WeatherUseCases {
  WeatherUseCases(WeatherRepository repository) : _repository = repository;
  final WeatherRepository _repository;

  Future<WeatherResponse> getWeatherData(double lat, double long) =>
      _repository.getWeatherData(lat, long);
}
