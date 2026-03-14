import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/services/post_service.dart';
import '../../core/services/api_service.dart';

class PostRepository {

  final PostService service = PostService(ApiService());

  Future<void> createPost({
    required String content,
    String? location,
    File? photo,
    Uint8List? webPhoto,
  }) async {

    MultipartFile? imageFile;

    if (kIsWeb && webPhoto != null) {
      imageFile = MultipartFile.fromBytes(
        webPhoto,
        filename: "post.jpg",
      );
    }

    if (!kIsWeb && photo != null) {
      imageFile = await MultipartFile.fromFile(
        photo.path,
        filename: photo.path.split("/").last,
      );
    }

    FormData data = FormData.fromMap({
      "content": content,
      if (location != null && location.isNotEmpty) "location": location,
      if (imageFile != null) "image": imageFile,
    });

    await service.createPost(data);
  }
}