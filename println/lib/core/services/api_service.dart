import 'package:dio/dio.dart';
import 'package:println/core/config/api_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {

  late final Dio dio;

  ApiService() {

    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {

          final user = FirebaseAuth.instance.currentUser;

          if (user != null) {

            final token = await user.getIdToken();

            print("TOKEN ENVIADO:");
            print(token);

            options.headers["Authorization"] = "Bearer $token";

          }

          handler.next(options);
        },
      ),
    );
  }

}