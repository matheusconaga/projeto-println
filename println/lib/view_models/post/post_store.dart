import 'dart:io';
import 'dart:typed_data';

import 'package:mobx/mobx.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:println/data/repositories/post_repository.dart';
import 'package:println/core/services/post_service.dart';

part 'post_store.g.dart';

class PostStore = _PostStore with _$PostStore;

abstract class _PostStore with Store {

  final PostService api;
  final PostRepository repository = PostRepository();

  _PostStore(this.api);

  @observable
  bool loading = false;

  @observable
  String? error;

  @action
  Future<void> createPost({
    required String content,
    String? location,
    File? selectedImage,
    Uint8List? webImage,
  }) async {

    loading = true;
    error = null;

    try {

      await repository.createPost(
        content: content,
        location: location,
        photo: selectedImage,
        webPhoto: webImage,
      );

    } catch (e) {

      error = "Erro ao criar post";

    }

    loading = false;
  }

  @action
  Future<void> editPost({
    required String postId,
    required String content,
    String? location,
    File? selectedImage,
    Uint8List? webImage,
  }) async {

    loading = true;

    try {

      MultipartFile? imageFile;

      if (kIsWeb && webImage != null) {
        imageFile = MultipartFile.fromBytes(
          webImage,
          filename: "post.jpg",
        );
      }

      if (!kIsWeb && selectedImage != null) {
        imageFile = await MultipartFile.fromFile(
          selectedImage.path,
        );
      }

      FormData data = FormData.fromMap({
        "content": content,
        "location": location,
        if (imageFile != null) "image": imageFile,
      });

      await api.editPost(postId, data);

    } catch (e) {

      error = "Erro ao editar post";

    }

    loading = false;

  }

  @action
  Future<void> deletePost(String postId) async {

    loading = true;

    try {

      await api.deletePost(postId);

    } catch (e) {

      error = "Erro ao deletar post";

    }

    loading = false;

  }

}