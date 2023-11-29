import 'package:first_test_project/modules/weather_module/application/usecases/weather_usecases.dart';
import 'package:first_test_project/modules/weather_module/domain/models/weather_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../app/service_locatator/service_locator.dart';
import '../../application/bloc/weather_bloc.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WeatherBloc>(
      create: (context) => WeatherBloc(sl<WeatherUseCases>())
        ..add(const WeatherEvent.getWeatherData()),
      child: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: const Center(
          child: SpinKitSpinningLines(
            color: Colors.white,
            size: 50.0,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.blue,
          body: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (BuildContext context, state) => state.when(
              initial: () {
                context.loaderOverlay.show();
                return const SizedBox.shrink();
              },
              loading: () {
                context.loaderOverlay.show();
                return const SizedBox.shrink();
              },
              loaded: (response) => _weatherUi(response, context),
              error: (error) {
                context.loaderOverlay.hide();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          error,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: error.contains("permanentlyDenied"),
                      child: _generalButton(
                        context,
                        title: "Open App Settings",
                        onTap: () {
                          openAppSettings();
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _generalButton(
                      context,
                      title: "Refresh",
                      onTap: () {
                        context
                            .read<WeatherBloc>()
                            .add(const WeatherEvent.getWeatherData());
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _weatherUi(WeatherResponse weatherResponse, BuildContext context) {
    context.loaderOverlay.hide();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          _locationWidget(weatherResponse.name ?? "No Name"),
          _todayDataAnDStatusWidget(
              weatherResponse.weather?.first.main ?? "No Status"),
          _temperatureWidget(weatherResponse.main?.temp ?? 273.15),
          _descriptionWidget(weatherResponse.main?.temp ?? 273.15,
              weatherResponse.name ?? "-"),
          _otherDetailsWidget(weatherResponse.wind?.speed,
              weatherResponse.main?.humidity, weatherResponse.visibility),
          _generalButton(context,
              title: "Refresh",
              onTap: () => context
                  .read<WeatherBloc>()
                  .add(const WeatherEvent.getWeatherData())),
        ],
      ),
    );
  }

  Widget _locationWidget(String location) {
    return Center(
      child: Text(
        location,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 35,
        ),
      ),
    );
  }

  Widget _todayDataAnDStatusWidget(String status) {
    DateTime currentDate = DateTime.now();
    DateFormat dateFormat = DateFormat('EEEE, d MMMM y');
    String formattedDate = dateFormat.format(currentDate);
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.black,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              child: Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            status,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _temperatureWidget(temperature) {
    num temp = temperature - 273.15;
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 10),
      child: Text(
        "${temp.round()}°",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 160,
        ),
      ),
    );
  }

  Widget _descriptionWidget(num temperature, String name) {
    num temp = (temperature - 273.15).round();

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily summary",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
              "Now it feels ${(temp + 5).toStringAsFixed(0)}°C in ${name ?? "No name"} , actually ${temp.toStringAsFixed(0)}. Today, the temperature is felt in the range from ${(temp - 7).toStringAsFixed(0)}° to ${(temp + 5).toStringAsFixed(0)}°"),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _otherDetailsWidget(windSpeed, humidity, visibility) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Column(
                children: [
                  const Icon(
                    Icons.wind_power_outlined,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "$windSpeed km/h",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 18),
                  ),
                  const Text(
                    "Wind",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  const Icon(
                    Icons.water_drop_outlined,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "$humidity%",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 18),
                  ),
                  const Text(
                    "Humidity",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "$visibility km",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 18),
                  ),
                  const Text(
                    "Visibility",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _generalButton(BuildContext context,
      {required String title, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 30),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
