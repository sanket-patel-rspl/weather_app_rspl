import 'package:first_test_project/core/services/location_service/location_repository.dart';
import 'package:first_test_project/core/services/location_service/location_repository_impl.dart';
import 'package:first_test_project/modules/weather_module/application/bloc/weather_bloc.dart';
import 'package:first_test_project/modules/weather_module/application/usecases/weather_usecases.dart';
import 'package:first_test_project/modules/weather_module/data/weather_network_source.dart';
import 'package:first_test_project/modules/weather_module/data/weather_repository_impl.dart';
import 'package:first_test_project/modules/weather_module/domain/repository/weather_repository.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void initGetIt() {
  ///Weather Module
  sl.registerFactory<WeatherBloc>(() => WeatherBloc(sl()));
  sl.registerFactory<WeatherUseCases>(() => WeatherUseCases(sl()));
  sl.registerFactory<WeatherRepository>(() => WeatherRepositoryImpl(sl()));
  sl.registerFactory<WeatherDataSource>(() => WeatherDataSource());

  ///Location Services
  sl.registerLazySingleton<LocationRepository>(() => LocationRepositoryImpl());
  sl.registerLazySingleton<LocationRepositoryImpl>(
      () => LocationRepositoryImpl());
}
