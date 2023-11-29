import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';

import '../../config/constants/constants.dart';

/// Singleton dio client class for only one class instants across the all over app
class DioClient {
  static Dio? _dioClient;

  static Dio? getClient() {
    if (_dioClient == null) {
      initClient();
    }
    return _dioClient;
  }

  static Dio? initClient() {
    _dioClient = Dio(BaseOptions(
      baseUrl: APIConstants.BASE_URL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    /// Interceptors for the each requests
    _dioClient!.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) {
      return handler.next(options);
    }, onResponse: (response, handler) {
      debugPrint(response.requestOptions.uri.toString());
      return handler.next(response);
    }, onError: (DioException e, handler) {
      debugPrint("Request : ${e.message}");
      return handler.next(e);
    }));

    /// Adding this code for bypassing the Certificate validation
    _dioClient?.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final HttpClient client =
            HttpClient(context: SecurityContext(withTrustedRoots: false));
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        return client;
      },
    );

    return _dioClient;
  }
}
