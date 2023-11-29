import 'package:first_test_project/modules/weather_module/data/weather_network_source.dart';

import '../domain/models/weather_response_model.dart';
import '../domain/repository/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  WeatherRepositoryImpl(WeatherDataSource source) : _dataSource = source;
  final WeatherDataSource _dataSource;

  @override
  Future<WeatherResponse> getWeatherData(double lat, double long) {
    return _dataSource.getWeatherData(lat, long);
  }
}
