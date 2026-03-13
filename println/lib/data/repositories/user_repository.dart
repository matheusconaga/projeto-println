
import 'package:println/core/services/api_service.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class UserRepository {

  final ApiService api = ApiService();

  Future<bool> checkEmail(String email) async {

    final response = await api.dio.get("/users/email/$email");

    return response.data["exists"];
  }

  Future<void> registerUser({
    required String firebaseUid,
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
      "firebase_uid": firebaseUid,
      "email": email,
      "username": username,
      if (multipartPhoto != null) "photo": multipartPhoto,
    });

    await api.dio.post(
      "/users/register-form",
      data: formData,
    );

  }
}