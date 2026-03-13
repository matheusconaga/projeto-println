import 'package:dio/dio.dart';
import 'package:println/core/config/api_config.dart';


class ApiService {

  late final Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );
  }


}