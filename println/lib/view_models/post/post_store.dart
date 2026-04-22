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

  @observable
  ObservableList<PostModel> savedPostsList = ObservableList<PostModel>();

  @observable
  ObservableMap<String, int> postComments = ObservableMap<String, int>();

  // LIKES
  @action
  Future<void> toggleLike(String postId, String userId) async {
    final currentlyLiked = likedPosts[postId] ?? false;

    final currentCount = postLikes[postId] ?? 0;

    likedPosts[postId] = !currentlyLiked;
    postLikes[postId] =
        (currentCount + (currentlyLiked ? -1 : 1)).clamp(0, double.infinity).toInt();

    try {
      if (currentlyLiked) {
        await api.unlikePost(postId, userId);
      } else {
        await api.likePost(postId, userId);
      }
    } catch (e) {
      likedPosts[postId] = currentlyLiked;
      postLikes[postId] = currentCount;

      error = "Erro ao atualizar like";
    }
  }

  @action
  Future<void> initializeLikes(
      String currentUserId, {
        required List<PostModel> feedPosts,
      }) async {
    try {
      final likedPostIds = await api.getUserLikes(currentUserId);

      likedPosts.clear();
      postLikes.clear();

      final likedSet = likedPostIds.toSet();

      for (var post in feedPosts) {
        likedPosts[post.id] = likedSet.contains(post.id);
        postLikes[post.id] = post.likes;
        postComments[post.id] = post.comments;
      }
    } catch (e) {
      error = "Erro ao carregar likes do usuário";
    }
  }

  // SAVES
  @action
  Future<void> toggleSave(String postId, String userId) async {
    final currentlySaved = savedPosts[postId] ?? false;

    final currentCount = postSaves[postId] ?? 0;

    savedPosts[postId] = !currentlySaved;
    postSaves[postId] =
        (currentCount + (currentlySaved ? -1 : 1)).clamp(0, double.infinity).toInt();

    try {
      if (currentlySaved) {
        await api.unsavePost(postId, userId);
      } else {
        await api.savePost(postId, userId);
      }
    } catch (e) {
      savedPosts[postId] = currentlySaved;
      postSaves[postId] = currentCount;

      error = "Erro ao atualizar save";
    }
  }

  @action
  Future<void> initializeSaves(
      String currentUserId, {
        required List<PostModel> feedPosts,
      }) async {
    try {
      final savedPostsJson = await api.getUserSaves(currentUserId);

      final savedIds = savedPostsJson.map<String>((p) => p['id'] as String).toSet();

      savedPosts.clear();
      postSaves.clear();

      for (var post in feedPosts) {
        savedPosts[post.id] = savedIds.contains(post.id);

        postSaves[post.id] = post.saves;
      }
    } catch (e) {
      error = "Erro ao carregar saves";
    }
  }

  @action
  Future<void> loadSavedPosts(String userId) async {
    loading = true;
    error = null;

    try {
      final response = await api.getUserSaves(userId);

      final posts = response
          .map<PostModel>((json) => PostModel.fromJson(json))
          .toList();

      savedPostsList.clear();
      savedPostsList.addAll(posts);

      for (var post in posts) {
        savedPosts[post.id] = true;
        postSaves[post.id] = post.saves;
      }

    } catch (e) {
      error = "Erro ao carregar posts salvos";
    } finally {
      loading = false;
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