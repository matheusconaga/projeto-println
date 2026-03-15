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
    return response.data["exists"];
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
      multipartPhoto = await MultipartFile.fromFile(photo.path);
    }

    if (webPhoto != null) {
      multipartPhoto = MultipartFile.fromBytes(
        webPhoto,
        filename: "profile.jpg",
      );
    }

    final formData = FormData.fromMap({
      "id": id,
      "email": email,
      "username": username,
      if (multipartPhoto != null) "photo": multipartPhoto,
    });

    final response = await api.dio.post(
      "/users/register-form",
      data: formData,
    );

    return UserModel.fromJson(response.data);
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      final response = await api.dio.get("/users/$id");
      return UserModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> updateUser(
      String userId,
      String? username,
      File? photo,
      Uint8List? webPhoto, {
        bool removePhoto = false,
      }) async {
    MultipartFile? multipartPhoto;

    if (photo != null) {
      multipartPhoto = await MultipartFile.fromFile(photo.path, filename: 'profile.jpg');
    }

    if (webPhoto != null) {
      multipartPhoto = MultipartFile.fromBytes(webPhoto, filename: 'profile.jpg');
    }

    final formData = FormData.fromMap({
      if (username != null) "username": username,
      if (multipartPhoto != null) "photo": multipartPhoto,
      "remove_photo": removePhoto.toString(),
    });

    final response = await api.dio.put(
      "/users/update/$userId",
      data: formData,
    );

    return UserModel.fromJson(response.data);
  }

}