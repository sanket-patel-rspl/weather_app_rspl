part of 'weather_bloc.dart';

@freezed
class WeatherEvent with _$WeatherEvent {
  /// by default this event will bring data for current location
  /// if want to get any other location data then only pass the lat long
  const factory WeatherEvent.getWeatherData({double? let, double? long}) =
      _GetWeatherData;
}
