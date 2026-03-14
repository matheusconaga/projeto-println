import 'package:dio/dio.dart';
import 'package:println/core/services/api_service.dart';

class PostService {

  final ApiService api;

  PostService(this.api);

  Future<void> createPost(FormData data) async {
    await api.dio.post("/posts/", data: data);
  }

  Future<void> editPost(String id, FormData data) async {
    await api.dio.put("/posts/$id", data: data);
  }

  Future<void> deletePost(String id) async {
    await api.dio.delete("/posts/$id");
  }

  Future<Response> getFeed(int page) async {
    return await api.dio.get("/posts/feed?page=$page");
  }

  // Funcoes do like
  Future<List<String>> getUserLikes(String userId) async {
    final response = await api.dio.get(
      "/likes/user_likes",
      queryParameters: {"user_id": userId},
    );

    return List<String>.from(response.data);
  }

  Future<void> likePost(String postId, String userId) async {
    await api.dio.post(
      "/likes/$postId/like",
      queryParameters: {"user_id": userId},
    );
  }

  Future<void> unlikePost(String postId, String userId) async {
    await api.dio.delete(
      "/likes/$postId/like",
      queryParameters: {"user_id": userId},
    );
  }

  // Funcoes do save
  Future<List<Map<String, dynamic>>> getUserSaves(String userId) async {
    final response = await api.dio.get(
      "/saves/user_saves",
      queryParameters: {"user_id": userId},
    );
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<void> savePost(String postId, String userId) async {
    await api.dio.post(
      "/saves/$postId/save",
      queryParameters: {"user_id": userId},
    );
  }

  Future<void> unsavePost(String postId, String userId) async {
    await api.dio.delete(
      "/saves/$postId/save",
      queryParameters: {"user_id": userId},
    );
  }

}