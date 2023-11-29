import 'package:first_test_project/core/exceptions/exceptions.dart';
import 'package:first_test_project/modules/weather_module/domain/models/weather_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../app/service_locatator/service_locator.dart';
import '../../../../core/services/location_service/location_repository_impl.dart';
import '../usecases/weather_usecases.dart';

part 'weather_event.dart';

part 'weather_state.dart';

part 'weather_bloc.freezed.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherUseCases _useCases;

  WeatherBloc(WeatherUseCases useCases)
      : _useCases = useCases,
        super(const WeatherState.initial()) {
    on<WeatherEvent>((event, emit) async {
      await event.when(
        getWeatherData: (lat, long) async {
          try {
            emit(const WeatherState.loading());
            Position position =
                await sl<LocationRepositoryImpl>().getCurrentLocation();
            var response = await _useCases.getWeatherData(
                position.latitude, position.longitude);
            emit(WeatherState.loaded(response));
          } catch (error) {
            if (error is CustomException) {
              emit(WeatherState.error(error.errorMessage));
              return;
            }
            emit(WeatherState.error(error.toString()));
          }
        },
      );
    });
  }
}
