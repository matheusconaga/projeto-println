import 'package:dio/dio.dart';
import 'package:println/core/services/api_service.dart';

class UserApiService {

  final ApiService api;

  UserApiService(this.api);

  // Aqui ele vai ver se o email já existe para mudar o fluxo
  Future<bool> checkEmail(String email) async {

    final response = await api.dio.get("/users/email/$email");

    return response.data["exists"];
  }

  // Registrar o usuário no banco de dados
  Future<void> registerUser({
    required String firebaseUid,
    required String email,
    required String username,
    String? photo,
  }) async {

    await api.dio.post(
      "/users/register",
      data: {
        "firebase_uid": firebaseUid,
        "email": email,
        "username": username,
        "photo": photo
      },
    );
  }
}