import 'package:first_test_project/modules/weather_module/data/weather_network_source.dart';
import 'package:first_test_project/modules/weather_module/domain/models/weather_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late WeatherDataSource weatherDataSource;

  setUpAll(() {
    weatherDataSource = WeatherDataSource();
  });

  test("getWeatherdata_whenCalledWithLatLong_returnWeatherResponse", () async {
    WeatherResponse data =
        await weatherDataSource.getWeatherData(22.3072, 73.1812);

    expect(data, isA<WeatherResponse>());
    expect(data.name, isNotEmpty);
    expect(data.main?.temp, isNotNull);
    expect(data.wind?.speed, isNotNull);
  });
}
