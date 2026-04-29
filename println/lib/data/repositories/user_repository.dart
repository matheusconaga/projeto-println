import 'package:println/core/services/api_service.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:println/models/user_model.dart';

class UserRepository {
  final ApiService api = ApiService();

  Future<bool> checkEmail(String email) async {
    final response = await api.dio.get("/users/email/$email");
    return response.data["exists"] ?? false;
  }

  Future<UserModel> registerUser({
    required String id,
    required String email,
    required String username,
    File? photo,
    Uint8List? webPhoto,
  }) async {
    MultipartFile? multipartPhoto;

    if (photo != null) {
      multipartPhoto = await MultipartFile.fromFile(photo.path, filename: 'profile.jpg');
    } else if (webPhoto != null) {
      multipartPhoto = MultipartFile.fromBytes(webPhoto, filename: 'profile.jpg');
    }

    final formData = FormData.fromMap({
      "id": id,
      "email": email,
      "username": username,
      if (multipartPhoto != null) "photo": multipartPhoto,
    });

    final response = await api.dio.post("/users/register", data: formData);
    return UserModel.fromJson(response.data);
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      final response = await api.dio.get("/users/$id");
      if (response.data != null) {
        return UserModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        debugPrint("Usuário $id ainda não existe no banco.");
        return null;
      }
      debugPrint("Erro de conexão/servidor: ${e.message}");
      rethrow;
    }
  }

  Future<UserModel> getMe() async {
    final response = await api.dio.get("/users/me");

    return UserModel.fromJson(response.data);
  }

  Future<UserModel> updateUser(
      String? username,
      File? photo,
      Uint8List? webPhoto, {
        bool removePhoto = false,
      }) async {
    MultipartFile? multipartPhoto;

    if (photo != null) {
      multipartPhoto = await MultipartFile.fromFile(photo.path, filename: 'profile.jpg');
    } else if (webPhoto != null) {
      multipartPhoto = MultipartFile.fromBytes(webPhoto, filename: 'profile.jpg');
    }

    final formData = FormData.fromMap({
      if (username != null) "username": username,
      if (multipartPhoto != null) "photo": multipartPhoto,
      "remove_photo": removePhoto,
    });

    final response = await api.dio.put("/users/update", data: formData);
    return UserModel.fromJson(response.data);
  }

  Future<UserModel?> waitForUser(String uid, {Duration timeout = const Duration(seconds: 5)}) async {
    final int intervalMs = 100;
    int elapsed = 0;

    while (elapsed < timeout.inMilliseconds) {
      final user = await getUserById(uid);
      if (user != null) return user;

      await Future.delayed(Duration(milliseconds: intervalMs));
      elapsed += intervalMs;
    }

    return null;
  }
}