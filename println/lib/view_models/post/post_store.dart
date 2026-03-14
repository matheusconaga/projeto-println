import 'dart:io';
import 'dart:typed_data';

import 'package:mobx/mobx.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:println/data/repositories/post_repository.dart';
import 'package:println/core/services/post_service.dart';
import 'package:println/models/post_model.dart';

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

  @observable
  ObservableMap<String, bool> likedPosts = ObservableMap<String, bool>();

  @observable
  ObservableMap<String, int> postLikes = ObservableMap<String, int>();

  @action
  Future<void> toggleLike(String postId, String userId) async {
    final currentlyLiked = likedPosts[postId] ?? false;

    try {
      if (currentlyLiked) {
        await api.unlikePost(postId, userId);
      } else {
        await api.likePost(postId, userId);
      }

      likedPosts[postId] = !currentlyLiked;
      postLikes[postId] = ((postLikes[postId] ?? 0) + (currentlyLiked ? -1 : 1))
          .clamp(0, double.infinity)
          .toInt();
    } catch (e) {
      error = "Erro ao atualizar like";
    }
  }

  @action
  Future<void> initializeLikes(String currentUserId, {List<PostModel>? feedPosts}) async {
    try {
      final likedPostIds = await api.getUserLikes(currentUserId);
      likedPosts.clear();
      for (var id in likedPostIds) {
        likedPosts[id] = true;
      }

      if (feedPosts != null) {
        for (var post in feedPosts) {
          postLikes[post.id] = post.likes;
        }
      }
    } catch (e) {
      error = "Erro ao carregar likes do usuário";
    }
  }

  @action
  Future<bool> createPost({
    required String content,
    String? location,
    File? selectedImage,
    Uint8List? webImage,
  }) async {
    loading = true;
    try {
      await repository.createPost(
        content: content,
        location: location,
        photo: selectedImage,
        webPhoto: webImage,
      );
      return true;
    } catch (e) {
      error = "Erro ao criar post";
      return false;
    } finally {
      loading = false;
    }
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
        imageFile = MultipartFile.fromBytes(webImage, filename: "post.jpg");
      }
      if (!kIsWeb && selectedImage != null) {
        imageFile = await MultipartFile.fromFile(selectedImage.path);
      }

      FormData data = FormData.fromMap({
        "content": content,
        "location": location,
        if (imageFile != null) "image": imageFile,
      });

      await api.editPost(postId, data);
    } catch (e) {
      error = "Erro ao editar post";
    } finally {
      loading = false;
    }
  }

  @action
  Future<void> deletePost(String postId) async {
    loading = true;
    try {
      await api.deletePost(postId);
      likedPosts.remove(postId);
      postLikes.remove(postId);
    } catch (e) {
      error = "Erro ao deletar post";
    } finally {
      loading = false;
    }
  }
}