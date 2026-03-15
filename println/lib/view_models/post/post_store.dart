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

  @observable
  ObservableMap<String, bool> savedPosts = ObservableMap<String, bool>();

  @observable
  ObservableMap<String, int> postSaves = ObservableMap<String, int>();

  @observable
  ObservableList<PostModel> feedPosts = ObservableList<PostModel>();

  // LIKES
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

  // SAVES
  @action
  Future<void> toggleSave(String postId, String userId) async {
    final currentlySaved = savedPosts[postId] ?? false;

    try {
      if (currentlySaved) {
        await api.unsavePost(postId, userId);
        postSaves[postId] = ((postSaves[postId] ?? 1) - 1).clamp(0, double.infinity).toInt();
      } else {
        await api.savePost(postId, userId);
        postSaves[postId] = ((postSaves[postId] ?? 0) + 1);
      }

      savedPosts[postId] = !currentlySaved;
    } catch (e) {
      error = "Erro ao atualizar save";
    }
  }

  @action
  Future<void> initializeSaves(String currentUserId) async {
    try {
      final savedPostsJson = await api.getUserSaves(currentUserId);

      savedPosts.clear();

      for (var postJson in savedPostsJson) {
        final post = PostModel.fromJson(postJson);
        savedPosts[post.id] = true;
      }
    } catch (e) {
      error = "Erro ao carregar posts salvos";
    }
  }


  // POSTS
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
  void setFeed(List<PostModel> posts) {
    feedPosts.clear();
    feedPosts.addAll(posts);
  }


  @action
  Future<void> editPost({
    required String postId,
    required String content,
    String? location,
    File? selectedImage,
    Uint8List? webImage,
    bool removeImage = false,
  }) async {

    loading = true;
    try {
      await repository.editPost(
        postId: postId,
        content: content,
        location: location,
        photo: selectedImage,
        webPhoto: webImage,
        removeImage: removeImage,
      );

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

      // feedPosts.removeWhere((p) => p.id == postId);

      likedPosts.remove(postId);
      postLikes.remove(postId);
      savedPosts.remove(postId);
      postSaves.remove(postId);

    } catch (e) {
      error = "Erro ao deletar post";
    } finally {
      loading = false;
    }
  }


}