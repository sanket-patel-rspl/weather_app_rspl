import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:first_test_project/core/exceptions/exceptions.dart';

import 'package:first_test_project/modules/weather_module/domain/models/weather_response_model.dart';

import '../../../config/constants/constants.dart';
import '../../../core/network/dio_client.dart';

/// This is network source for the [WeatherRepositoryImpl]
/// Which will bring the data from network
class WeatherDataSource {
  Future<WeatherResponse> getWeatherData(double lat, double long) async {
    try {
      Response? response = await DioClient.getClient()?.get(
        APIConstants.API_VERSION + APIConstants.WEATHER_API,
        queryParameters: {
          "lat": lat,
          "lon": long,
          "appId": APIConstants.APP_ID
        },
      );

      if (response != null && response.statusCode == 200) {
        return WeatherResponse.fromJson(response.data);
      } else {
        throw CustomException("There is an error in API calling");
      }
    } catch (error) {
      if (error is SocketException || error is TimeoutException) {
        throw CustomException("Please check you internet connection");
      }
      if (error is DioException) {
        throw CustomException("Please check you internet connection");
      }
      throw (CustomException(error.toString()));
    }
  }
}
