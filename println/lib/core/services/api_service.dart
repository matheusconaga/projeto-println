import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'secure_storage_service.dart';

class ApiService {
  late final Dio dio;
  final SecureStorageService storage = SecureStorageService();

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.getToken();

          if (token != null) {
            options.headers["Authorization"] =
            "Bearer $token";
          }

          handler.next(options);
        },
      ),
    );
  }
}