import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';

import '../config/api_config.dart';
import 'secure_storage_service.dart';

class ApiService {
  late final Dio dio;
  final storage = SecureStorageService();

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: kIsWeb ? null : const Duration(seconds: 20),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.getToken();

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }

          print("➡️ ${options.method} ${options.uri}");

          handler.next(options);
        },

        onResponse: (response, handler) {
          print("✅ ${response.statusCode} ${response.requestOptions.path}");
          handler.next(response);
        },

        onError: (error, handler) {
          print("❌ ${error.response?.statusCode}");
          print("❌ ${error.response?.data}");
          handler.next(error);
        },
      ),
    );

    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );
  }
}