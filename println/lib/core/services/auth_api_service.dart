import 'package:println/core/services/api_service.dart';

class AuthApiService {
  final ApiService api;

  AuthApiService(this.api);

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await api.dio.post(
      "/auth/login",
      data: {
        "email": email,
        "password": password,
      },
    );

    return response.data["access_token"];
  }

}